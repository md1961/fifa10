class RosterChartsController < ApplicationController

  PROPERTY_NAME_CANDIDATES = [:overall, :skill_move, :is_right_dominant, :both_feet_level, :height, :age]
  DEFAULT_ATTRIBUTE_TO_SHOW = :overall

  def index
    @season_id = get_season_id(params)
    @is_lineup = params[:is_lineup] == '1'

    unless @is_lineup
      set_players_to_row_filter_if_not

      if session[:ticket_to_examine_player_status_change]
        examine_player_status_change
        session[:ticket_to_examine_player_status_change] = nil
      end
      recover_disabled
    end

    report = session[:roster_chart_report]
    session[:roster_chart_report] = nil
    flash[:report] = report && report.html_safe

    @error_explanation = session[:error_explanation]
    session[:error_explanation] = nil

    @season = Season.find(@season_id)
    @formation = @season.formation

    SimpleDB.instance.async

    @players = players_of_team(includes_on_loan=true, for_lineup=@is_lineup)

    SimpleDB.instance.sync

    @next_matches = Match.nexts(@season_id)

    @num_starters, @num_in_bench = get_num_starters_and_in_bench

    @injury_list = get_injury_list
    @off_list    = get_off_list

    @attr = params[:attribute] || DEFAULT_ATTRIBUTE_TO_SHOW
    @attrs = (PROPERTY_NAME_CANDIDATES + ColumnFilter::FIELD_ATTRIBUTE_NAMES).sort

    @page_title_size = 3
    @page_title = "#{team_name_and_season_years} Roster Chart"
  end

  def edit_roster
    is_lineup = params[:is_lineup] == '1'

    SimpleDB.instance.async

    players = players_of_team(includes_on_loan=true, for_lineup=is_lineup)
    commands = parse_roster_edit_command(params[:command], players)
    is_redirected = commands && update_roster(commands, players, is_lineup, params[:is_undoing] == '1')
    return if is_redirected

    SimpleDB.instance.sync

    h_params = {:is_lineup => is_lineup ? 1 : 0}
    is_action_show = commands && commands.first == ACTION_SHOW
    redirect_to is_action_show ? players_path(h_params) : roster_chart_path(h_params)
  end

  def revise_lineup
    season = Season.find(get_season_id(params))
    formation = season.formation
    inactive_player_ids = get_inactive_player_ids(season.id)

    num_starters = Constant.get(:num_starters)
    num_in_bench = Constant.get(:num_in_bench)

    replace_one_player = Proc.new { |index, index0_replacer|
      players = players_of_team(includes_on_loan=false, for_lineup=true)
      player = players[index]
      next unless inactive_player_ids.include?(player.id)
      position = index < num_starters ? formation.position(index + 1) : player.position

      replacing_players = players[index0_replacer .. -1]
      player_sub = Player.player_available_with_max_overall(position, replacing_players, inactive_player_ids)
      exchange_player_order(player, player_sub, is_lineup=true) if player_sub
    }

    SimpleDB.instance.async
    num_starters.times { |index| replace_one_player.call(index, num_starters) }
    SimpleDB.instance.sync

    num_lineup_all = num_starters + num_in_bench
    SimpleDB.instance.async
    num_starters.upto(num_lineup_all) { |index| replace_one_player.call(index, num_lineup_all) }
    SimpleDB.instance.sync

    redirect_to roster_chart_path(:is_lineup => 1)
  end

  def apply_formation
    @is_lineup = params[:is_lineup] == '1'

    season = Season.find(get_season_id(params))
    season.formation_id = params[:id]
    season.save!

    redirect_to roster_chart_path(:is_lineup => @is_lineup ? 1 : 0)
  end

  def pick_injury
    season_id = get_season_id(params)
    players_disabled = Array.new
    players_injured  = Array.new

    if Constant.get(:uses_disable_only_mode)
      players = players_for_injury
      player_ids = players.map(&:id).sort_by { rand }
      max_disabled = rand(Constant.get(:max_disabled_on_disable_only_mode) + 1)
      if max_disabled > 0
        player_ids.each do |id|
          player = Player.find(id)
          if player.to_be_disabled?(season_id)
            players_disabled << player
            break if players_disabled.size >= max_disabled
          end
        end
      end
    else
      injury_list = get_injury_list

      players = do_pick_players(injury_list)
      players_disabled = players.select { |player| player.to_be_disabled?(season_id) }
      players_injured = players - players_disabled

      injury_list.concat(players_injured.map(&:id))
      set_injury_list(injury_list)
    end

    disable_players(players_disabled)

    put_injury_report_into_session(players_disabled, players_injured)

    caller_path_method = :"#{params[:caller]}_path"
    redirect_to send(caller_path_method, :is_lineup => params[:is_lineup])
  end

  def undo_pick_injury
    injury_list = get_injury_list
    unless injury_list.empty?
      injury_list.pop
      set_injury_list(injury_list)
    end

    caller_path_method = :"#{params[:caller]}_path"
    redirect_to send(caller_path_method, :is_lineup => params[:is_lineup])
  end

  def clear_injury
    set_injury_list(Array.new)
    set_off_list(   Array.new)

    caller_path_method = :"#{params[:caller]}_path"
    redirect_to send(caller_path_method, :is_lineup => params[:is_lineup])
  end

  def numbers
    @is_lineup = params[:is_lineup] == '1'

    @players = players_of_team(includes_on_loan=true, for_lineup=@is_lineup)
    @min_overall_to_emphasize = 80

    @page_title_size = 3
    @page_title = "#{team_name_and_season_years} Playing Numbers"
  end

  def disablement_check
    @players = players_of_team(includes_on_loan=true, for_lineup=false)
    @season_id = get_season_id(params)
  end

  private

    def get_inactive_player_ids(season_id)
      inactive_players = players_of_team.select { |player| player.inactive?(season_id) }
      return get_injury_list + get_off_list + inactive_players.map(&:id)
    end

    def players_for_injury(injury_list=[])
      players = players_of_team(includes_loan=false)
      season_id = get_season_id
      players.reject! { |player|
        injury_list.include?(player.id) || player.inactive?(season_id) || player.hot?(season_id)
      }
      return players
    end

    def disable_players(players, toggles=false, no_date_until_change=false)
      season_id = get_season_id
      players.each do |player|
        player.disable(season_id, toggles, no_date_until_change)
      end
    end

    def set_disabled_until(player, days_disabled)
      is_offset = days_disabled =~ /\A[+-]/
      days = days_disabled.to_i
      if days == 0
        explain_error("Illegal argument", ["Days must be a non-zero integer"], [])
        return
      end

      season_id = get_season_id(params)
      next_match = Match.nexts(season_id, 1)
      unless next_match
        explain_error("Illegal command", ["Cannot do 'until' with no next match"], [])
        return
      end
      disabled_until = player.disabled_until(season_id)
      date_from = is_offset ? disabled_until : next_match.date_match

      session[:former_days_disabled] = is_offset ? -(days_disabled.to_i) : disabled_until - date_from
      date_until = date_from + days.days
      player.set_disabled_until(date_until, season_id)
    end

    MAX_NUMBER_OF_PLAYERS_TO_PICK = 5

    def do_pick_players(injury_list)
      players = players_for_injury(injury_list)

      num = rand(MAX_NUMBER_OF_PLAYERS_TO_PICK) + 1
      picks = Array.new
      num.times do
        picks << players.sample
      end
      return picks
    end

    def put_injury_report_into_session(players_disabled, players_injured)
      uses_disable_only_mode = Constant.get(:uses_disable_only_mode)

      array_of_players = [players_disabled]
      array_of_players << players_injured unless uses_disable_only_mode
      reports = Array.new
      array_of_players.each_with_index do |players, index|
        next if players.empty? && ! uses_disable_only_mode
        verb = index == 0 ? 'disabled' : 'injured'
        reports << "#{players.size} player(s) #{verb}: #{players.map(&:name).join(', ')}"
      end
      session[:roster_chart_report] = reports.empty? ? nil : reports.join("<br />")
    end

    def examine_player_status_change
      season_id = get_season_id
      players = players_of_team(includes_on_loan=false, for_lineup=true)
      players.each do |player|
        increment      = player.examine_disabled_until_change(season_id)
        status_expired = player.examine_hot_or_not_well_expire(season_id)
        next unless increment || status_expired

        report = session[:roster_chart_report] || ""
        report += "<br />" unless report.empty?
        if increment
          verb = increment > 0 ? 'delayed' : 'advanced'
          report += "#{player.name}'s return was #{verb} by #{increment.abs} day(s)"
        else
          report += "#{player.name}'s hot/not_well status expired"
        end
        session[:roster_chart_report] = report
      end
    end

    def recover_disabled
      season_id = get_season_id
      next_match = Match.nexts(season_id).first
      return unless next_match
      today = next_match.date_match
      players = players_of_team(includes_on_loan=false, for_lineup=true)
      players_recoverd = Array.new
      players.each do |player|
        is_recovered = player.recover_from_disabled(today, season_id)
        players_recoverd << player if is_recovered
      end

      #TODO: Merge into put_injury_report_into_session()
      if players_recoverd.size > 0
        report = "#{players_recoverd.size} player(s) recovered: #{players_recoverd.map(&:name).join(', ')}"
        report_in_session = session[:roster_chart_report] || ""
        session[:roster_chart_report] = report_in_session + "<br />" + report
      end
    end

    def get_num_starters_and_in_bench
      num_starters = Constant.get(:num_starters)
      num_in_bench = Constant.get(:num_in_bench)
      return num_starters, num_in_bench
    end

    def set_injury_list(injury_list)
      set_list_to_simple_db(:injury_list, injury_list)
    end

    def set_off_list(off_list)
      set_list_to_simple_db(:off_list, off_list)
    end

    def set_list_to_simple_db(name, list)
      raise ArgumentError.new("Argument must be an Array") unless list.kind_of?(Array)
      SimpleDB.instance.set(name, list)
    end

    ACTION_WITH    = 'with'
    ACTION_TO      = 'to'
    ACTION_LOAN    = 'loan'
    ACTION_INJURE  = 'injure'
    ACTION_RECOVER = 'recover'
    ACTION_OFF     = 'off'
    ACTION_HOT     = 'hot'
    ACTION_NOTWELL = 'notwell'
    ACTION_DISABLE = 'disable'
    ACTION_UNTIL   = 'until'
    ACTION_SHOW    = 'show'
    ACTION_UNDO    = 'z'

    LEGAL_ACTIONS = [
      ACTION_WITH, ACTION_TO, ACTION_LOAN, ACTION_INJURE, ACTION_RECOVER, ACTION_OFF,
      ACTION_HOT, ACTION_NOTWELL, ACTION_DISABLE, ACTION_UNTIL, ACTION_SHOW, ACTION_UNDO,
    ]

    MAP_NUM_PLAYERS = {
      ACTION_WITH  => 2,
      ACTION_TO    => 2,
      ACTION_UNTIL => 2,
    }

    def update_roster(commands, players, is_lineup, is_undoing)
      action, players_arg = commands
      unless players_arg_legal?(players_arg, action)
        return
      end
      if action == ACTION_LOAN && is_lineup
        explain_error("Illegal command", ["loan command not allowed in lineup mode"], [])
        return
      end

      str_undo_command = nil
      str_player_numbers = players_arg.select { |arg| arg.is_a?(Player) }.map(&:number).join(' ')
      Player.transaction do
        case action
        when ACTION_WITH
          player1, player2 = players_arg
          exchange_player_order(player1, player2, is_lineup)
          str_undo_command = "#{ACTION_WITH} #{player1.number} #{player2.number}"
        when ACTION_TO
          player1, player2 = players_arg
          number_to_when_undoing = insert_player_order_before(player1, player2, players, is_lineup)
          str_undo_command = "#{ACTION_TO} #{player1.number} #{number_to_when_undoing}" if number_to_when_undoing
        when ACTION_LOAN
          loan_player(players_arg)
          str_undo_command = "#{ACTION_LOAN} #{str_player_numbers}"
        when ACTION_INJURE
          put_into_injury(players_arg)
        when ACTION_RECOVER
          recover_from_injury(players_arg)
          str_undo_command = "#{ACTION_DISABLE} #{str_player_numbers}"
        when ACTION_OFF
          off_player(players_arg)
          str_undo_command = "#{ACTION_OFF} #{str_player_numbers}"
        when ACTION_HOT
          hot_player(players_arg)
          str_undo_command = "#{ACTION_HOT} #{str_player_numbers}"
        when ACTION_NOTWELL
          not_well_player(players_arg)
          str_undo_command = "#{ACTION_NOTWELL} #{str_player_numbers}"
        when ACTION_DISABLE
          disable_players(players_arg, toggles=true, no_date_until_change=is_undoing)
          str_undo_command = "#{ACTION_DISABLE} #{str_player_numbers}"
        when ACTION_UNTIL
          player, days_disabled = players_arg
          set_disabled_until(player, days_disabled)
          former_days_disabled = session[:former_days_disabled]
          str_undo_command = "#{ACTION_UNTIL} #{player.number} #{former_days_disabled}" if former_days_disabled
        when ACTION_SHOW
          show_player_attributes(players_arg)
        when ACTION_UNDO
          is_redirected = undo_command(is_lineup)
          return is_redirected if is_redirected
        else
          raise ActiveRecord::Rollback, "Unknown action '#{action}' in helper update_roster()"
        end
      end

      save_undo_command(str_undo_command)

      return false
    end

    def save_undo_command(str_undo_command)
      session[:undo_command_in_roster_chart] = str_undo_command
    end

    def undo_command(is_lineup)
      command = session[:undo_command_in_roster_chart]
      unless command
        explain_error("Nothing to do", ["No previous command to undo"], [])
        return redirected = false
      end

      session[:undo_command_in_roster_chart] = nil
      redirect_to edit_roster_roster_charts_path(:command => command, :is_undoing => 1, :is_lineup => is_lineup ? 1 : 0)
      return redirected = true
    end

    def players_arg_legal?(players_arg, action)
      legal_num_players = MAP_NUM_PLAYERS[action]
      return true unless legal_num_players
      is_legal = players_arg.size == legal_num_players
      unless is_legal
        msg = "Number of players must be #{legal_num_players} (#{players_arg.size} given)"
        explain_error("Illegal number of players", [msg], [])
      end
      return is_legal
    end

    def exchange_player_order(player1, player2, is_lineup)
      season_id = is_lineup ? 0 : get_season_id(params)
      n1 = player1.order_number(season_id)
      n2 = player2.order_number(season_id)
      player1.set_order_number(999999, season_id)
      player1.save! unless is_lineup
      player2.set_order_number(n1, season_id)
      player2.save! unless is_lineup
      player1.set_order_number(n2, season_id)
      player1.save! unless is_lineup
    end

    def insert_player_order_before(player1, player2, players, is_lineup)
      index1 = players.index(player1)
      index2 = players.index(player2)
      return if index1 == index2
      if index1.nil? || index2.nil?
        names = Array.new
        names << player1.name if index1.nil?
        names << player2.name if index2.nil?
        raise ActiveRecord::Rollback, "Cannot find Player '#{names.join("', '")}' in 'players'"
      end

      season_id = is_lineup ? 0 : get_season_id(params)
      player1 = players[index1]
      n_prev = player1.order_number(season_id)
      player1.set_order_number(999999, season_id)
      player1.save! unless is_lineup

      step = sgn(index2 - index1)
      player_number_to_when_undoing = players[index1 + step].number
      (index1 + step).step(index2, step) do |index|
        player = players[index]
        n = player.order_number(season_id)
        player.set_order_number(n_prev, season_id)
        player.save! unless is_lineup
        n_prev = n
      end
      player1.set_order_number(n_prev, season_id)
      player1.save! unless is_lineup

      return player_number_to_when_undoing
    end

    def loan_player(players)
      season_id = get_season_id(params)
      players.each do |player|
        on_loan = player.on_loan?(season_id)
        player.set_on_loan(! on_loan, season_id)
      end
    end

    def put_into_injury(players)
      injury_list = get_injury_list
      season_id = get_season_id

      players.each do |player|
        if injury_list.include?(player.id)
          explain_error("Cannot injure", ["'#{player.name}' is already in injury list"], [])
          return
        elsif player.hot?(season_id)
          explain_error("Cannot injure", ["'#{player.name}' is in hot status"], [])
          return
        end
      end

      players.each do |player|
        injury_list << player.id
        set_injury_list(injury_list)
      end

      put_injury_report_into_session([], players)
    end

    def recover_from_injury(players)
      injury_list = get_injury_list
      season_id = get_season_id

      players.each do |player|
        is_injured = injury_list.include?(player.id)
        next unless is_injured || player.disabled?(season_id)
        if is_injured
          injury_list.delete(player.id)
          set_injury_list(injury_list)
        else
          player.disable(season_id, true)
        end
      end
    end

    def off_player(players)
      off_list    = get_off_list
      injury_list = get_injury_list

      players.each do |player|
        player_id = player.id
        next if injury_list.include?(player_id)
        if off_list.include?(player_id)
          off_list.delete(player_id)
        else
          off_list << player_id
        end
      end

      set_off_list(off_list)
    end

    def hot_player(players)
      season_id = get_season_id(params)
      players.each do |player|
        is_hot = player.hot?(season_id)
        player.set_hot(! is_hot, season_id)
      end
    end

    def not_well_player(players)
      season_id = get_season_id(params)
      players.each do |player|
        is_not_well = player.not_well?(season_id)
        player.set_not_well(! is_not_well, season_id)
      end
    end

    def show_player_attributes(players_arg)
      row_filter = get_row_filter(nil, for_lineup=true)
      row_filter.set_no_players
      players_arg.each do |player|
        row_filter.set_player_by_name(player.name)
      end

      set_row_filter(row_filter)
    end

    NORMAL_TERMS_SIZE = 3
    RE_ACTION = /\A[a-zA-Z]+\z/
    PLAYER_FORMAT = "\\d{1,2}"
    RE_PLAYER = /\A#{PLAYER_FORMAT}\z/

    def parse_roster_edit_command(command, players)
      if command.blank?
        explain_error("", ["No command specified"], [])
        return nil
      end

      title = "Command \"#{command}\" was illegal"
      terms = command2terms(command)
      terms.insert(0, ACTION_WITH) if terms.size == 2 && RE_PLAYER =~ terms[0] && RE_PLAYER =~ terms[1]
      terms.insert(1, terms.shift) unless RE_ACTION =~ terms.first

      action = complete_action(terms.first)
      return nil unless action
      unless LEGAL_ACTIONS.include?(action)
        explain_error(title, ["Unknown command '#{command}'"], [])
        return nil
      end

      additional_args = Array.new
      additional_args << terms.pop if action == ACTION_UNTIL

      players_arg = terms2players(terms[1 .. -1], players, title)
      return nil unless players_arg

      return action, players_arg + additional_args
    end

    def command2terms(command)
      terms = command.split
      terms = terms.map { |term| term.split(/([ a-zA-Z]+)/) }
      terms.flatten!
      return terms.reject { |term| term.blank? }
    end

    def complete_action(action)
      candidates = LEGAL_ACTIONS.select { |a| a.starts_with?(action) }
      if candidates.size >= 2
        title = "Action \"#{action} is ambiguous"
        msg   = "Cannot pick from '#{candidates.join('\', \'')}'"
        explain_error(title, [msg], [])
        return nil
      end
      return candidates.size == 1 ? candidates[0] : action
    end

    RE_SERIAL_PLAYERS = /\A(#{PLAYER_FORMAT})-(#{PLAYER_FORMAT})\z/

    def terms2players(terms, players, title)
      terms_here = nil
      #FIXME: Deactivate?
      terms_here = parse_serial_players($1, $2) if false && terms.size == 1 && terms[0] =~ RE_SERIAL_PLAYERS
      terms_here = terms unless terms_here 

      players_from_terms = terms_here.map { |term| term2player(term, players) }
      return players_from_terms if players_from_terms.all? { |player| player }

      illegal_players = Array.new
      players_from_terms.each_with_index do |player, index|
        illegal_players << terms_here[index] unless player
      end
      players = "'#{illegal_players.join("' and '")}'"
      mult = illegal_players.size > 1
      message = "#{players} #{mult ? 'are' : 'is'} illegal player#{mult ? 's' : ''}"
      explain_error(title, [message], [])

      return nil
    end

    def parse_serial_players(term1, term2)
      kind1 = player_kind(term1)
      kind2 = player_kind(term2)
      return nil if kind1 != kind2

      index1 = player_index(term1)
      index2 = player_index(term2)
      return nil if index1 > index2

      return (index1 .. index2).to_a.map { |index| "#{kind1}#{index}" }
    end

    RE_NUMBER = /\A\d+\z/

    def player_kind(term)
      term = "s#{term}" if term =~ RE_NUMBER
      kind = term[0, 1]
      return nil unless %w(s b r).include?(kind)
      return kind
    end

    def player_index(term)
      return term.sub(/\A[sbr]/, "").to_i
    end

    def term2player(term, players)
      return players.find { |player| player.number == term.to_i }
    end

    def parse_commant_to_filter(command)
      command = command.strip
      if command.blank?
        explain_error("No command specified", ["No command specified"], [])
        return false
      end

      row_filter = get_row_filter

      title = "Command '#{command}' specified"

      kind = nil
      names = Array.new
      command.split.each do |name|
        name = name.downcase
        if kind.nil?
          is_position = RowFilter.position?(name)
          is_player   = RowFilter.player_name_match(name).size > 0
          if ! is_position && ! is_player
            explain_error(title, ["Unknown position/player name '#{name}'"], [])
            return false
          end
          kind = is_position ? 'position' : 'player'
        end
        found = kind == 'position' ? RowFilter.position?(name) : RowFilter.player_name_match(name).size > 0
        unless found
          explain_error(title, ["Unknown #{kind} name '#{name}'"], [])
          return false
        end
        names << name
      end

      row_filter.send(:"set_no_#{kind}s")
      names.each do |name|
        begin
          row_filter.send(:"set_#{kind}_by_name", name)
        rescue RowFilter::CannotFindPlayerException
          explain_error(title, ["Unknown Player name '#{name}'"], [])
          return false
        end
      end

      set_row_filter(row_filter)

      return true
    end

    def explain_error(title, texts, lists)
      session[:error_explanation] = ErrorExplanation.new(title, texts, lists)
      return
    end
end

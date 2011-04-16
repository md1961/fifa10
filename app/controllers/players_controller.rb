class PlayersController < ApplicationController

  def index
    season_id = get_season_id(params)
    @is_lineup = params[:is_lineup] == '1'

    row_filter = get_row_filter(nil, for_lineup=@is_lineup)
    @players = row_filter.displaying_players

    redirect_to choose_filter_players_path if @players.empty? && ! players_of_team.empty?

    sort_fields = session[:sort_fields]
    @sorted_field_names = []
    if sort_fields
      sort_players(@players, sort_fields)
      @sorted_field_names = sort_fields.map(&:name)
    end

    column_filter = get_column_filter
    no_attributes = @players.all? { |player| player.player_attribute.all_zero? }
    column_filter.set_all_or_no_attributes(false) if no_attributes

    @columns           = column_filter.displaying_columns
    @attribute_columns = column_filter.displaying_attribute_columns

    @attribute_top_five_values = Player.player_attribute_top_values(5, season_id)

    @chronicle = Season.find(season_id).chronicle

    @page_title_size = 3
    @page_title = "#{team_name_and_season_years} Rosters"
  end

  PLAYER_ATTRIBUTE_ORDER =
    [:acceleration, :quickness, :balance, :jump, :reaction, :speed, :stamina, :physical,
     :positiveness, :positioning, :tactics, :vision,
     :control, :cross, :curve, :dribble, :goalmaking, :fk_accuracy, :head_accuracy,
     :long_pass, :long_shot, :mark, :pk, :short_pass, :shot_power, :sliding, :tackle, :volley,
     :gk_dive, :gk_handling, :gk_kick, :gk_positioning, :gk_reaction]

  def show
    row_filter = get_row_filter
    players = row_filter.displaying_players
    players = players_of_team if params[:browses_all_players]
    @player = Player.find(params[:id])
    @is_from_roster_chart = params[:is_from_roster_chart] == '1'
    @prev_player, @next_player = prev_and_next_players(@player, players)

    @player_attribute_order = PLAYER_ATTRIBUTE_ORDER.map(&:to_s)

    @page_title_size = 3
    @page_title = "#{@player.number} #{@player.last_name_first_name}"
  end

  def edit
    row_filter = get_row_filter
    players = row_filter.displaying_players
    @player = Player.find(params[:id])
    @is_from_list = params[:is_from_list] == '1'
    @is_from_roster_chart = params[:is_from_roster_chart] == '1'
    @prev_player, @next_player = prev_and_next_players(@player, players)

    @player_attribute_order = PLAYER_ATTRIBUTE_ORDER.map(&:to_s)

    @page_title_size = 3
    @page_title = "Editing #{@player.last_name_first_name} ..."
  end
  
  def update
    season_id = get_season_id(params)
    adjust_params(season_id)
    @player = Player.find(params[:id])
    begin
      ActiveRecord::Base::transaction do
        unless @player.update_attributes(params[:player])
          raise ActiveRecord::Rollback, "Player update failed"
        end
        unless @player.player_attribute.update_attributes(params[:player_attribute])
          raise ActiveRecord::Rollback, "PlayerAttribute update failed"
        end
      end
      flash[:notice] = "Player '#{@player.name}' has been successfully updated"
      if params[:is_from_list] == 'true'
        redirect_to players_path
      else
        redirect_to player_path(@player, :is_from_roster_chart => params[:is_from_roster_chart])
      end
    rescue
      flash[:error_message] = "Failed to update Player '#{@player.name}'"
      redirect_to [:edit, @player]
    end
  end

    def adjust_params(season_id)
      season = Season.find(season_id)
      birth_year = params[:player][:birth_year].to_i
      params[:player][:birth_year] = season.year_start - birth_year if birth_year.between?(1, 99)
    end
    private :adjust_params

  def new
    @player = Player.new
    @player.overall = 0
    @player.player_attribute = PlayerAttribute.zeros

    season_id = get_season_id
    season = Season.find(season_id)
    @player.nation = season.team if season.national_team?

    @player_attribute_order = PLAYER_ATTRIBUTE_ORDER.map(&:to_s)

    prepare_page_title_for_new
  end

  def create
    season_id = session[:season_id]
    adjust_params(season_id)
    @player = Player.new(params[:player])
    @player.set_next_order_number(season_id)
    @player.player_attribute = PlayerAttribute.new(params[:player_attribute])
    begin
      @player.save!
      redirect_to @player
    rescue ActiveRecord::RecordInvalid
      @player_attribute_order = PLAYER_ATTRIBUTE_ORDER.map(&:to_s)
      flash[:error_message] = "Failed to create Player '#{@player.name}'"
      prepare_page_title_for_new
      render 'new'
    end
  end

  def remove_from_rosters
    season_id = session[:season_id]
    player = Player.find(params[:id])
    player.remove_from_rosters(season_id)

    redirect_to players_path
  end

  def prepare_page_title_for_new
    @page_title_size = 3
    @page_title = "Creating a new Player ..."
  end
  private :prepare_page_title_for_new

  NUM_SORT_FIELDS = 3

  def choose_sort
    @sort_fields = session[:sort_fields]
    if @sort_fields.nil? || @sort_fields.size != NUM_SORT_FIELDS
      @sort_fields = Array.new
      NUM_SORT_FIELDS.times do |i|
        @sort_fields << SortField.new
      end
    end

    @page_title_size = 3
    @page_title = "Choose Items to Sort by"
  end

  def clear_sort
    sort_fields = Array.new
    NUM_SORT_FIELDS.times do |i|
      sort_fields << SortField.new
    end
    session[:sort_fields] = sort_fields

    redirect_to players_path
  end

  def prepare_sort
    sort_fields = Array.new
    NUM_SORT_FIELDS.times do |i|
      param = params[:sort_field][i.to_s]
      name = param[:name]
      ascending  = param[:ascending] == '1'
      sort_fields << SortField.new(name, ascending)
    end
    session[:sort_fields] = sort_fields

    if params[:shows_sort_only] == '1'
      attribute_names = sort_fields.map(&:name).select { |name| name != 'none' }
      filter_with_specified_attributes([DESIGNATED_ATTRIBUTES], attribute_names)
    else
      redirect_to players_path
    end
  end

  def choose_filter
    @row_filter    = get_row_filter
    @column_filter = get_column_filter

    @error_explanation = session[:error_explanation]
    session[:error_explanation] = nil
    @last_command = session[:last_command_to_filter] || ""

    @page_title_size = 3
    @page_title = "Choose Items to Display"
  end

  def filter
    row_filter = get_row_filter(params)
    set_row_filter(row_filter)

    column_filter = get_column_filter(params)
    session[:column_filter] = column_filter

    redirect_to players_path
  end

  def filter_command
    command = params[:command]
    session[:last_command_to_filter] = command
    is_good = parse_commant_to_filter(command)

    redirect_to is_good ? players_path : choose_filter_players_path
  end

  RECOMMENDED_COLUMNS = 'recommended_columns'
  ALL_COLUMNS         = 'all_columns'
  NO_COLUMNS          = 'no_columns'

  GENERAL_ATTRIBUTES = 'general_attributes'
  OFFENSIVE_ATTRIBUTES = 'offensive_attributes'
  DEFENSIVE_ATTRIBUTES = 'defensive_attributes'
  GOALKEEPING_ATTRIBUTES = 'goalkeeping_attributes'
  DESIGNATED_ATTRIBUTES  = 'designated_attributes'
  ALL_ATTRIBUTES = 'all_attributes'
  NO_ATTRIBUTES  = 'no_attributes'

  ALL_POSITION_CATEGORIES = 'all_position_categories'
  NO_POSITION_CATEGORIES  = 'no_position_categories'

  def filter_with
    case params[:filter].to_sym
    when :recommended_columns
      filter_with_specified_columns(RECOMMENDED_COLUMNS)
    when :all_columns
      filter_with_specified_columns(ALL_COLUMNS)
    when :no_columns
      filter_with_specified_columns(NO_COLUMNS)
    when :field_attributes
      filter_with_specified_attributes([GENERAL_ATTRIBUTES, OFFENSIVE_ATTRIBUTES, DEFENSIVE_ATTRIBUTES])
    when :general_attributes
      filter_with_specified_attributes([GENERAL_ATTRIBUTES])
    when :offensive_attributes
      filter_with_specified_attributes([OFFENSIVE_ATTRIBUTES])
    when :defensive_attributes
      filter_with_specified_attributes([DEFENSIVE_ATTRIBUTES])
    when :general_and_offensive_attributes
      filter_with_specified_attributes([GENERAL_ATTRIBUTES, OFFENSIVE_ATTRIBUTES])
    when :general_and_defensive_attributes
      filter_with_specified_attributes([GENERAL_ATTRIBUTES, DEFENSIVE_ATTRIBUTES])
    when :goalkeeping_attributes
      filter_with_specified_attributes([GOALKEEPING_ATTRIBUTES])
    when :all_attributes
      filter_with_specified_attributes([ALL_ATTRIBUTES])
    when :no_attributes
      filter_with_specified_attributes([NO_ATTRIBUTES])
    when :all_position_categories
      filter_with_specified_position_categories(ALL_POSITION_CATEGORIES)
    when :no_position_categories
      filter_with_specified_position_categories(NO_POSITION_CATEGORIES)
    end
  end

    def filter_with_specified_columns(columns)
      column_filter = get_column_filter
      if columns == RECOMMENDED_COLUMNS
        column_filter.set_recommended_columns
      else
        column_filter.set_all_or_no_columns(columns == ALL_COLUMNS)
      end
      session[:column_filter] = column_filter

      redirect_to players_path
    end
    private :filter_with_specified_columns

    def filter_with_specified_attributes(list_of_attributes, attribute_names=nil)
      column_filter = get_column_filter
      column_filter.set_all_or_no_attributes(false)

      list_of_attributes.each do |attributes|
        case attributes
        when GENERAL_ATTRIBUTES
          column_filter.set_general_attributes
        when OFFENSIVE_ATTRIBUTES
          column_filter.set_offensive_attributes
        when DEFENSIVE_ATTRIBUTES
          column_filter.set_defensive_attributes
        when GOALKEEPING_ATTRIBUTES
          column_filter.set_goalkeeping_attributes
        when DESIGNATED_ATTRIBUTES
          column_filter.set_specified_attributes(attribute_names)
        else
          column_filter.set_all_or_no_attributes(attributes == ALL_ATTRIBUTES)
        end
      end

      session[:column_filter] = column_filter

      redirect_to players_path
    end

    def filter_with_specified_position_categories(categories)
      row_filter = get_row_filter
      row_filter.set_all_or_no_position_categories(categories == ALL_POSITION_CATEGORIES)
      set_row_filter(row_filter)

      redirect_to players_path
    end
    private :filter_with_specified_position_categories

  def attribute_legend
    @abbrs_with_full = PlayerAttribute.abbrs_with_full

    @page_title_size = 3
    @page_title = "Player Attribute Legend"
  end

  POSITION_NAMES_IN_DEPTH_CHART = %w(GK SW CB RB RWB LB LWB CDM CM CAM RM RW LM LW RF LF CF ST)
  PROPERTY_NAMES_IN_DEPTH_CHART = [:overall, :skill_move, :is_right_dominant, :both_feet_level,
                                   :height, :age]
  DEFAULT_ATTRIBUTE_IN_DEPTH_CHART = :overall

  def depth_chart
    @no_logout = true
    @is_lineup = params[:is_lineup] == '1'

    SimpleDB.instance.async

    players = players_of_team(includes_on_loan=false, for_lineup=@is_lineup)

    SimpleDB.instance.sync

    @attr = params[:attribute] || DEFAULT_ATTRIBUTE_IN_DEPTH_CHART
    @attrs = PROPERTY_NAMES_IN_DEPTH_CHART + ColumnFilter::FIELD_ATTRIBUTE_NAMES

    @depth = Hash.new { |hash, key| hash[key] = Array.new }
    Position.find(:all).each do |position|
      players_at_position = players.select { |player| player.positions.include?(position) }
      players_at_position.each do |player|
        @depth[position] << player
      end
      @depth[position].sort! { |p1, p2| (p1.get(@attr) <=> p2.get(@attr)) * -1 }
    end

    @positions = POSITION_NAMES_IN_DEPTH_CHART.map { |name| Position.find_by_name(name) }

    @next_matches = Match.nexts(get_season_id)

    @season_id   = get_season_id
    @injury_list = get_injury_list
    @off_list    = get_off_list

    @page_title_size = 3
    @page_title = "#{team_name_and_season_years} Depth Chart"
  end

  def roster_chart
    @no_logout = true
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

    @page_title_size = 3
    @page_title = "#{team_name_and_season_years} Roster Chart"
  end

    def set_players_to_row_filter_if_not
      RowFilter.players = players_of_team unless RowFilter.players
    end
    private :set_players_to_row_filter_if_not

    def get_num_starters_and_in_bench
      num_starters = Constant.get(:num_starters)
      num_in_bench = Constant.get(:num_in_bench)
      return num_starters, num_in_bench
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
    private :examine_player_status_change

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
    private :recover_disabled

  def edit_roster
    is_lineup = params[:is_lineup] == '1'

    SimpleDB.instance.async

    players = players_of_team(includes_on_loan=true, for_lineup=is_lineup)
    commands = parse_roster_edit_command(params[:command], players)
    update_roster(commands, players, is_lineup) if commands

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

    def get_inactive_player_ids(season_id)
      inactive_players = players_of_team.select { |player| player.inactive?(season_id) }
      return get_injury_list + get_off_list + inactive_players.map(&:id)
    end
    private :get_inactive_player_ids

  def apply_formation
    @is_lineup = params[:is_lineup] == '1'

    season = Season.find(get_season_id(params))
    season.formation_id = params[:id]
    season.save!

    redirect_to roster_chart_path(:is_lineup => @is_lineup ? 1 : 0)
  end

  def top_attribute_list
    @no_logout = true
    num_top = 5

    @is_lineup = params[:is_lineup] == '1'

    season_id = get_season_id(params)
    set_players_to_row_filter_if_not

    players = players_of_team
    @top_values = Player.player_attribute_top_values(num_top, season_id)
    @map_top_players = Hash.new { |h, k| h[k] = Array.new }
    PlayerAttribute.fulls.each do |attr_name|
      top_players = players.select do |player|
        player.player_attribute.read_attribute(attr_name) >= @top_values[attr_name.to_s]
      end
      sort_players(top_players, [SortField.new(attr_name)])
      @map_top_players[attr_name].concat(top_players)
    end

    @names = params[:names]
    @players_focus = Array.new
    (@names || "").split.each do |name|
      @players_focus.concat(RowFilter.player_name_match(name))
    end

    @attr_names_focus = Array.new
    @map_top_players.each do |attr_name, players|
      players.each do |player|
        if @players_focus.include?(player)
          @attr_names_focus << attr_name
          break
        end
      end
    end

    @page_title_size = 3
    @page_title = "#{team_name_and_season_years} Top Attribute Chart"
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

    def players_for_injury(injury_list=[])
      players = players_of_team(includes_loan=false)
      season_id = get_season_id
      players.reject! { |player|
        injury_list.include?(player.id) || player.inactive?(season_id) || player.hot?(season_id)
      }
    end
    private :players_for_injury

    def disable_players(players, toggles=false)
      season_id = get_season_id
      players.each do |player|
        player.disable(season_id, toggles)
      end
    end
    private :disable_players

    def set_disabled_until(player, days_disabled)
      is_offset = days_disabled =~ /\A[+-]/
      days = days_disabled.to_i
      if days == 0
        explain_error("Illegal argument", ["Days must be a non-zero integer"], [])
        return
      end

      season_id = get_season_id(params)
      next_match = Match.nexts(season_id, 1).first
      unless next_match
        explain_error("Illegal command", ["Cannot do 'until' with no next match"], [])
        return
      end
      date_from = is_offset ? player.disabled_until(season_id) : next_match.date_match

      date_until = date_from + days.days
      player.set_disabled_until(date_until, season_id)
    end
    private :set_disabled_until

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
    private :do_pick_players

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
    private :put_injury_report_into_session

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

  def disablement_check
    @players = players_of_team(includes_on_loan=true, for_lineup=false)
    @season_id = get_season_id(params)

    @no_logout = true
  end

  private

    def get_injury_list
      get_list_from_simple_db(:injury_list)
    end

    def set_injury_list(injury_list)
      set_list_to_simple_db(:injury_list, injury_list)
    end

    def get_off_list
      get_list_from_simple_db(:off_list)
    end

    def set_off_list(off_list)
      set_list_to_simple_db(:off_list, off_list)
    end

    def get_list_from_simple_db(name)
      return SimpleDB.instance.get(name) || Array.new
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

    LEGAL_ACTIONS = [
      ACTION_WITH, ACTION_TO, ACTION_LOAN, ACTION_INJURE, ACTION_RECOVER, ACTION_OFF,
      ACTION_HOT, ACTION_NOTWELL,  ACTION_DISABLE, ACTION_UNTIL, ACTION_SHOW
    ]

    MAP_NUM_PLAYERS = {
      ACTION_WITH  => 2,
      ACTION_TO    => 2,
      ACTION_UNTIL => 2,
    }

    def update_roster(commands, players, is_lineup)
      action, players_arg = commands
      unless players_arg_legal?(players_arg, action)
        return
      end
      if action == ACTION_LOAN && is_lineup
        explain_error("Illegal command", ["loan command not allowed in lineup mode"], [])
        return
      end

      begin
        Player.transaction do
          case action
          when ACTION_WITH
            player1, player2 = players_arg
            exchange_player_order(player1, player2, is_lineup)
          when ACTION_TO
            player1, player2 = players_arg
            insert_player_order_before(player1, player2, players, is_lineup)
          when ACTION_LOAN
            loan_player(players_arg)
          when ACTION_INJURE
            put_into_injury(players_arg)
          when ACTION_RECOVER
            recover_from_injury(players_arg)
          when ACTION_OFF
            off_player(players_arg)
          when ACTION_HOT
            hot_player(players_arg)
          when ACTION_NOTWELL
            not_well_player(players_arg)
          when ACTION_DISABLE
            disable_players(players_arg, toggles=true)
          when ACTION_UNTIL
            player, days_disabled = players_arg
            set_disabled_until(player, days_disabled)
          when ACTION_SHOW
            show_player_attributes(players_arg)
          else
            raise ActiveRecord::Rollback, "Unknown action '#{action}' in helper update_roster()"
          end
        end
      #rescue
        #explain_error("DB Error", ["Failed database transaction"], [])
      end
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
      (index1 + step).step(index2, step) do |index|
        player = players[index]
        n = player.order_number(season_id)
        player.set_order_number(n_prev, season_id)
        player.save! unless is_lineup
        n_prev = n
      end
      player1.set_order_number(n_prev, season_id)
      player1.save! unless is_lineup
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
      terms = command.split
      terms.insert(0, ACTION_WITH) if terms.size == 2 && RE_PLAYER =~ terms[0] && RE_PLAYER =~ terms[1]
      terms.insert(1, terms.shift) unless RE_ACTION =~ terms.first

      action = complete_action(terms.first)
      return nil unless action
      unless LEGAL_ACTIONS.include?(action)
        legal_actions = "'" + LEGAL_ACTIONS.join("', '") + "'"
        explain_error(title, ["Legal actions are #{legal_actions}"], [])
        return nil
      end

      additional_args = Array.new
      additional_args << terms.pop if action == ACTION_UNTIL

      players_arg = terms2players(terms[1 .. -1], players, title)
      return nil unless players_arg

      return action, players_arg + additional_args
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

    def sort_players(players, sort_fields)
      players.sort! { |player1, player2| compare_players(player1, player2, sort_fields) }
    end

    def compare_players(player1, player2, sort_fields)
      sort_fields.each do |field|
        name = field.name
        return 0 if name.to_s == 'none'

        ascending = field.ascending?
        value1 = player1.get(name) || 0
        value2 = player2.get(name) || 0
        cmp = sgn(value1 - value2) * (ascending ? 1 : -1)
        return cmp if cmp != 0
      end

      return 0
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

    def get_row_filter(params=nil, for_lineup=false)
      #TODO: Rewrite with simple if ... else ...
      param = params ? params[:row_filter] : nil
      row_filter = param ? nil : session[:row_filter]
      row_filter = RowFilter.new(param) unless row_filter

      includes_on_loan = true
      row_filter.players = players_of_team(includes_on_loan, for_lineup) if row_filter

      return row_filter
    end

    def set_row_filter(row_filter)
      session[:row_filter] = row_filter
    end

    def get_column_filter(params=nil)
      param = params ? params[:column_filter] : nil
      column_filter = param ? nil : session[:column_filter]
      column_filter = ColumnFilter.new(param) unless column_filter
      return column_filter
    end

    def prev_and_next_players(player, players)
      index = players.index(player)
      return nil, nil unless index

      size = players.size
      prev_index = index == 0 ? size - 1 : index - 1
      next_index = index == size - 1 ? 0 : index + 1
      return [players[prev_index], players[next_index]]
    end
end

class PlayersController < ApplicationController

  def list
    season_id = get_season_id(params)

    row_filter = get_row_filter
    @players = row_filter.displaying_players
    @players = @players.select { |player| ! player.on_loan?(season_id) }

    #TODO: Think why this line was added
    #redirect_to :action => 'choose_to_list' if @players.empty?

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

    def get_season_id(params={})
      season_id = (params[:season_id] || session[:season_id]).to_i
      if season_id.nil? || season_id <= 0
        raise "No 'season_id' in params nor session (#{session.inspect})"
      end
      session[:season_id] = season_id
      return season_id
    end
    private :get_season_id

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
        redirect_to :action => 'list'
      else
        redirect_to @player
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
      flash[:error_message] = "Failed to create Player '#{@player.name}'"
      prepare_page_title_for_new
      render :action => 'new'
    end
  end

  def remove_from_rosters
    season_id = session[:season_id]
    player = Player.find(params[:id])
    player.remove_from_rosters(season_id)

    redirect_to :action => 'list'
  end

  def prepare_page_title_for_new
    @page_title_size = 3
    @page_title = "Creating a new Player ..."
  end
  private :prepare_page_title_for_new

  NUM_SORT_FIELDS = 3

  def choose_to_sort
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

  def clear_all_sort_fields
    sort_fields = Array.new
    NUM_SORT_FIELDS.times do |i|
      sort_fields << SortField.new
    end
    session[:sort_fields] = sort_fields

    redirect_to :action => 'list'
  end

  def prepare_sort_fields
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
      redirect_to :action => 'list'
    end
  end

  def choose_to_list
    @row_filter    = get_row_filter
    @column_filter = get_column_filter

    @error_explanation = session[:error_explanation]
    session[:error_explanation] = nil
    @last_command = session[:last_command_to_filter] || ""

    @page_title_size = 3
    @page_title = "Choose Items to Display"
  end

  def filter_on_list
    row_filter = get_row_filter(params)
    session[:row_filter] = row_filter

    column_filter = get_column_filter(params)
    session[:column_filter] = column_filter

    redirect_to :action => 'list'
  end

  def take_command_to_filter
    command = params[:command]
    session[:last_command_to_filter] = command
    is_good = parse_commant_to_filter(command)

    redirect_to :action => is_good ? 'list' : 'choose_to_list'
  end

  RECOMMENDED_COLUMNS = 'recommended_columns'
  ALL_COLUMNS         = 'all_columns'
  NO_COLUMNS          = 'no_columns'

  def filter_with_recommended_columns
    filter_with_specified_columns(RECOMMENDED_COLUMNS)
  end
  def filter_with_all_columns
    filter_with_specified_columns(ALL_COLUMNS)
  end
  def filter_with_no_columns
    filter_with_specified_columns(NO_COLUMNS)
  end

    def filter_with_specified_columns(columns)
      column_filter = get_column_filter
      if columns == RECOMMENDED_COLUMNS
        column_filter.set_recommended_columns
      else
        column_filter.set_all_or_no_columns(columns == ALL_COLUMNS)
      end
      session[:column_filter] = column_filter

      redirect_to :action => 'list'
    end
    private :filter_with_specified_columns

  GENERAL_ATTRIBUTES = 'general_attributes'
  OFFENSIVE_ATTRIBUTES = 'offensive_attributes'
  DEFENSIVE_ATTRIBUTES = 'defensive_attributes'
  GOALKEEPING_ATTRIBUTES = 'goalkeeping_attributes'
  DESIGNATED_ATTRIBUTES  = 'designated_attributes'
  ALL_ATTRIBUTES = 'all_attributes'
  NO_ATTRIBUTES  = 'no_attributes'

  def filter_with_field_attributes
    filter_with_specified_attributes([GENERAL_ATTRIBUTES, OFFENSIVE_ATTRIBUTES, DEFENSIVE_ATTRIBUTES])
  end
  def filter_with_general_attributes
    filter_with_specified_attributes([GENERAL_ATTRIBUTES])
  end
  def filter_with_offensive_attributes
    filter_with_specified_attributes([OFFENSIVE_ATTRIBUTES])
  end
  def filter_with_defensive_attributes
    filter_with_specified_attributes([DEFENSIVE_ATTRIBUTES])
  end
  def filter_with_general_and_offensive_attributes
    filter_with_specified_attributes([GENERAL_ATTRIBUTES, OFFENSIVE_ATTRIBUTES])
  end
  def filter_with_general_and_defensive_attributes
    filter_with_specified_attributes([GENERAL_ATTRIBUTES, DEFENSIVE_ATTRIBUTES])
  end
  def filter_with_goalkeeping_attributes
    filter_with_specified_attributes([GOALKEEPING_ATTRIBUTES])
  end
  def filter_with_all_attributes
    filter_with_specified_attributes([ALL_ATTRIBUTES])
  end
  def filter_with_no_attributes
    filter_with_specified_attributes([NO_ATTRIBUTES])
  end

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

      redirect_to :action => 'list'
    end

  ALL_POSITION_CATEGORIES = 'all_position_categories'
  NO_POSITION_CATEGORIES  = 'no_position_categories'

  def filter_with_all_position_categories
    filter_with_specified_position_categories(ALL_POSITION_CATEGORIES)
  end
  def filter_with_no_position_categories
    filter_with_specified_position_categories(NO_POSITION_CATEGORIES)
  end

    def filter_with_specified_position_categories(categories)
      row_filter = get_row_filter
      row_filter.set_all_or_no_position_categories(categories == ALL_POSITION_CATEGORIES)
      session[:row_filter] = row_filter

      redirect_to :action => 'list'
    end
    private :filter_with_specified_position_categories

  def show_attribute_legend
    @abbrs_with_full = PlayerAttribute.abbrs_with_full

    @page_title_size = 3
    @page_title = "Player Attribute Legend"
  end

  POSITION_NAMES_IN_DEPTH_CHART = %w(GK SW CB RB RWB LB LWB CDM CM CAM RM RW LM LW RF LF CF ST)
  PROPERTY_NAMES_IN_DEPTH_CHART = [:overall, :skill_move, :is_right_dominant, :both_feet_level,
                                   :height, :age]
  DEFAULT_ATTRIBUTE_IN_DEPTH_CHART = :overall

  def depth_chart
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

    @injury_list = get_injury_list

    @page_title_size = 3
    @page_title = "#{team_name_and_season_years} Depth Chart"
  end

  def roster_chart
    @is_lineup = params[:is_lineup] == '1'
    @is_lineup = session[:is_lineup] unless params[:is_lineup]
    session[:is_lineup] = @is_lineup

    @error_explanation = session[:error_explanation]
    session[:error_explanation] = nil

    @season_id = get_season_id(params)
    @season = Season.find(@season_id)
    @formation = @season.formation

    SimpleDB.instance.async

    @players = players_of_team(includes_on_loan=true, for_lineup=@is_lineup)

    SimpleDB.instance.sync

    @next_matches = Match.nexts(@season_id)

    @num_starters, @num_in_bench = get_num_starters_and_in_bench

    @injury_list = get_injury_list

    @page_title_size = 3
    @page_title = "#{team_name_and_season_years} Roster Chart"
  end

    def get_num_starters_and_in_bench
      num_starters = Constant.get(:num_starters)
      num_in_bench = Constant.get(:num_in_bench)
      return num_starters, num_in_bench
    end

  def edit_roster
    is_lineup = params[:is_lineup] == '1'

    SimpleDB.instance.async

    players = players_of_team(includes_on_loan=true, for_lineup=is_lineup)
    commands = parse_roster_edit_command(params[:command], players)
    update_roster(commands, players, is_lineup) if commands

    SimpleDB.instance.sync

    redirect_to :action => 'roster_chart', :is_lineup => is_lineup ? 1 : 0
  end

  def revise_lineup
    season = Season.find(get_season_id(params))
    formation = season.formation
    injury_list = get_injury_list

    num_starters = Constant.get(:num_starters)
    num_in_bench = Constant.get(:num_in_bench)

    replace_one_player = Proc.new { |index|
      players = players_of_team(includes_on_loan=false, for_lineup=true)
      player = players[index]
      next unless injury_list.include?(player.id)
      position = index < num_starters ? formation.position(index + 1) : player.position

      player_sub = Player.player_available_with_max_overall(position, injury_list, season.id)
      exchange_player_order(player, player_sub, is_lineup=true) if player_sub
    }

    SimpleDB.instance.async
      num_starters.times { |index| replace_one_player.call(index) }
    SimpleDB.instance.sync

    SimpleDB.instance.async
      num_starters.upto(num_starters + num_in_bench) { |index| replace_one_player.call(index) }
    SimpleDB.instance.sync

    redirect_to :action => 'roster_chart', :is_lineup => 1
  end

  def apply_formation
    season = Season.find(get_season_id(params))
    season.formation_id = params[:id]
    season.save!

    redirect_to :action => 'roster_chart'
  end

  def top_attribute_list
    num_top = 5

    season_id = get_season_id(params)

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

    get_row_filter # to set RowFilter::@@players
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

  def pick_player_for_injury
    injury_list = get_injury_list

    players = do_pick_players(injury_list)
    injury_list.concat(players.map(&:id))
    set_injury_list(injury_list)

    redirect_to :action => params[:caller], :is_lineup => params[:is_lineup]
  end

    MAX_NUMBER_OF_PLAYERS_TO_PICK = 5

    def do_pick_players(injury_list)
      players = players_of_team(includes_loan=false)
      players.reject! { |player| injury_list.include?(player.id) }

      num = rand(MAX_NUMBER_OF_PLAYERS_TO_PICK) + 1
      picks = Array.new
      num.times do
        picks << players.rand
      end
      return picks
    end
    private :do_pick_players

  def undo_pick_from_injury
    injury_list = get_injury_list
    unless injury_list.empty?
      injury_list.pop
      set_injury_list(injury_list)
    end

    redirect_to :action => params[:caller], :is_lineup => params[:is_lineup]
  end

  def clear_injury_list
    set_injury_list(Array.new)

    redirect_to :action => params[:caller], :is_lineup => params[:is_lineup]
  end

  private

    def get_injury_list
      return SimpleDB.instance.get(:injury_list) || Array.new
    end

    def set_injury_list(injury_list)
      raise ArgumentError.new("Argument injury_list must be an Array") unless injury_list.kind_of?(Array)
      SimpleDB.instance.set(:injury_list, injury_list)
    end

    ACTION_WITH    = 'with'
    ACTION_TO      = 'to'
    ACTION_LOAN    = 'loan'
    ACTION_INJURE  = 'injure'
    ACTION_RECOVER = 'recover'
    ACTION_SHOW    = 'show'
    LEGAL_ACTIONS = [ACTION_WITH, ACTION_TO, ACTION_LOAN, ACTION_INJURE, ACTION_RECOVER, ACTION_SHOW]

    def update_roster(commands, players, is_lineup)
      action, player1, player2 = commands
      if action == ACTION_LOAN && is_lineup
        explain_error("Illegal command", ["loan command not allowed in lineup"], [])
        return
      end

      begin
        Player.transaction do
          case action
          when ACTION_WITH
            exchange_player_order(player1, player2, is_lineup)
          when ACTION_TO
            insert_player_order_before(player1, player2, players, is_lineup)
          when ACTION_LOAN
            loan_player(player2)
          when ACTION_INJURE
            put_into_injury(player2)
          when ACTION_RECOVER
            recover_from_injury(player2)
          when ACTION_SHOW
            #show_player_attributes()
          else
            raise ActiveRecord::Rollback, "Unknown action '#{action}' in helper update_roster()"
          end
        end
      #rescue
        #explain_error("DB Error", ["Failed database transaction"], [])
      end
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

    def loan_player(player)
      season_id = get_season_id(params)
      on_loan = player.on_loan?(season_id)
      player.set_on_loan(! on_loan, season_id)
    end

    def put_into_injury(player)
      injury_list = get_injury_list
      if injury_list.include?(player.id)
        explain_error("Player already in injury list", ["'#{player.name}' is already in injury list"], [])
      else
        injury_list << player.id
        set_injury_list(injury_list)
      end
    end

    def recover_from_injury(player)
      injury_list = get_injury_list
      unless injury_list.include?(player.id)
        explain_error("No such player in injury list", ["'#{player.name}' is not in injury list"], [])
      else
        injury_list.delete(player.id)
        set_injury_list(injury_list)
      end
    end

    def copy_to_lineup(players)
      season_id = get_season_id(params)

      map_lineup = Hash.new
      players.each do |player|
        map_lineup[player.id] = player.order_number(season_id)
      end

      SimpleDB.instance.set(:map_lineup, map_lineup)
    end

    NORMAL_TERMS_SIZE = 3

    def parse_roster_edit_command(command, players)
      if command.blank?
        explain_error("", ["No command specified"], [])
        return nil
      end

      title = "Command \"#{command}\" was illegal"
      terms = command.split
      terms.unshift('s1') if terms.size < NORMAL_TERMS_SIZE
      unless terms.size == NORMAL_TERMS_SIZE
        explain_error(title, ["Command must be \"p# to/with p#\" or \"loan p#\""], [])
        return nil
      end

      action = complete_action(terms[1])
      return nil unless action
      unless LEGAL_ACTIONS.include?(action)
        legal_actions = "'" + LEGAL_ACTIONS.join("', '") + "'"
        explain_error(title, ["Legal actions are #{legal_actions}"], [])
        return nil
      end

      players = terms2players(terms, players, title)
      return nil unless players

      return [action, *players]
    end

    def complete_action(action)
      candidates = LEGAL_ACTIONS.select { |a| a.starts_with?(action) }
      if candidates.size >= 2
        title = "Action \"#{action} is ambiguous"
        msg   = "Cannot determine whether it is '#{candidates.join('\' or \'')}'"
        explain_error(title, [msg], [])
        return nil
      end
      return candidates.size == 1 ? candidates[0] : action
    end

    def terms2players(terms, players, title)
      player1 = term2player(terms[0], players)
      player2 = term2player(terms[2], players)
      return [player1, player2] if player1 && player2

      illegal_players = Array.new
      illegal_players << terms[0] unless player1
      illegal_players << terms[2] unless player2
      players = "'#{illegal_players.join("' and '")}'"
      mult = illegal_players.size > 1
      message = "#{players} #{mult ? 'are' : 'is'} illegal player#{mult ? 's' : ''}"
      explain_error(title, [message], [])

      return nil
    end

    def term2player(term, players)
      kind = term[0, 1]
      return nil unless %w(s b r).include?(kind)
      index = term[1..-1].to_i
      return nil if index <= 0

      num_starters, num_in_bench = get_num_starters_and_in_bench
      return nil if kind == 's' && index > num_starters
      return nil if kind == 'b' && index > num_in_bench
      return nil if kind == 'r' && index > players.size - num_starters - num_in_bench
      player_index = index - 1
      player_index += num_starters unless kind == 's'
      player_index += num_in_bench if     kind == 'r'

      return players[player_index]
    end

    def sort_players(players, sort_fields)
      players.sort! { |player1, player2| compare_players(player1, player2, sort_fields) }
    end

    def compare_players(player1, player2, sort_fields)
      sort_fields.each do |field|
        name = field.name
        return 0 if name.to_s == 'none'

        ascending = field.ascending?
        value1 = player1.get(name)
        value2 = player2.get(name)
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

      eval("row_filter.set_no_#{kind}s")
      names.each do |name|
        begin
          eval("row_filter.set_#{kind}_by_name(name)")
        rescue RowFilter::CannotFindPlayerException
          explain_error(title, ["Unknown Player name '#{name}'"], [])
          return false
        end
      end

      session[:row_filter] = row_filter

      return true
    end

    def explain_error(title, texts, lists)
      session[:error_explanation] = ErrorExplanation.new(title, texts, lists)
      return
    end

    def get_row_filter(params=nil)
      param = params ? params[:row_filter] : nil
      row_filter = param ? nil : session[:row_filter]
      row_filter = RowFilter.new(param) unless row_filter

      row_filter.players = players_of_team if row_filter

      return row_filter
    end

    def get_column_filter(params=nil)
      param = params ? params[:column_filter] : nil
      column_filter = param ? nil : session[:column_filter]
      column_filter = ColumnFilter.new(param) unless column_filter
      return column_filter
    end

    def players_of_team(includes_on_loan=true, for_lineup=false)
      season_id = session[:season_id]
      raise "no 'season_id' in session (#{session.inspect})" unless season_id
      players = Player.list(season_id, includes_on_loan, for_lineup)

      copy_to_lineup(players) unless for_lineup

      return players
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

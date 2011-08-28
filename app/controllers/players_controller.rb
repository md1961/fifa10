class PlayersController < ApplicationController

  def index
    season_id = get_season_id(params)
    @is_lineup = params[:is_lineup] == '1'
    @attr = params[:attribute]

    row_filter = get_row_filter(nil, for_lineup=@is_lineup)
    row_filter.set_all_players if @is_lineup && params[:all_players] == '1'
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

    if @is_lineup
      column_filter.set_recommended_columns
      column_filter.set_recommended_attributes
    end

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

  GENERAL_ATTRIBUTES     = 'general_attributes'
  OFFENSIVE_ATTRIBUTES   = 'offensive_attributes'
  DEFENSIVE_ATTRIBUTES   = 'defensive_attributes'
  GOALKEEPING_ATTRIBUTES = 'goalkeeping_attributes'
  RECOMMENDED_ATTRIBUTES = 'recommended_attributes'
  DESIGNATED_ATTRIBUTES  = 'designated_attributes'
  ALL_ATTRIBUTES         = 'all_attributes'
  NO_ATTRIBUTES          = 'no_attributes'

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
    when :recommended_attributes
      filter_with_specified_attributes([RECOMMENDED_ATTRIBUTES])
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
        when RECOMMENDED_ATTRIBUTES
          column_filter.set_recommended_attributes
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
  PROPERTY_NAMES_IN_DEPTH_CHART = [:overall, :skill_move, :is_right_dominant, :both_feet_level, :height, :age]
  DEFAULT_ATTRIBUTE_IN_DEPTH_CHART = :overall

  def depth_chart
    @is_lineup = params[:is_lineup] == '1'

    SimpleDB.instance.async

    players = players_of_team(includes_on_loan=false, for_lineup=@is_lineup)

    SimpleDB.instance.sync

    @attr = params[:attribute] || DEFAULT_ATTRIBUTE_IN_DEPTH_CHART
    @attrs = (PROPERTY_NAMES_IN_DEPTH_CHART + ColumnFilter::FIELD_ATTRIBUTE_NAMES).sort

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

  def top_attribute_list
    num_top = 5

    @is_lineup = params[:is_lineup] == '1'

    season_id = get_season_id(params)
    set_players_to_row_filter_if_not unless @is_lineup

    players = players_of_team(includes_on_loan=false, for_lineup=@is_lineup)
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

  private

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
end

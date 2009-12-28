class PlayersController < ApplicationController

  def list
    session[:team_id] = team_id = 1

    row_filter = get_row_filter
    @players = row_filter.displaying_players

    sort_fields = session[:sort_fields]
    sort_players(@players, sort_fields) if sort_fields

    column_filter = get_column_filter
    @columns = column_filter.displaying_columns
    @attribute_columns = column_filter.displaying_attribute_columns

    team = Team.find(team_id)
    @page_title = "#{team.name} Rosters"
  end

  def show
    @player = Player.find(params[:id])
    @prev_player, @next_player = prev_and_next_players(@player)

    @page_title = "#{@player.number} #{@player.last_name_first_name}"
  end

  def edit
    @player = Player.find(params[:id])
    @prev_player, @next_player = prev_and_next_players(@player)

    @page_title = "Editing #{@player.last_name_first_name} ..."
  end
  
  def update
    @player = Player.find(params[:id])
    begin
      ActiveRecord::Base::transaction do
        unless @player.update_attributes(params[:player])
          raise ActiveRecord::Rollback, "Player update failed"
        end
        flash[:notice] = "Player '#{@player.name}' has been successfully updated"
        redirect_to @player
      end
    rescue
      flash[:error_message] = "Failed to update Player '#{@player.name}'"
      redirect_to [:edit, @player]
    end
  end

  NUM_SORT_FIELDS = 3

  def choose_to_sort
    @sort_fields = Array.new
    NUM_SORT_FIELDS.times do |i|
      @sort_fields << SortField.new
    end

    @page_title = "Choose Items to Sort by"
  end

  def prepare_sort_fields
    sort_fields = Array.new
    NUM_SORT_FIELDS.times do |i|
      param = params[i.to_s]
      field_name = param[:field_name]
      ascending  = param[:ascending] == '1'
      sort_fields << SortField.new(field_name, ascending)
    end
    session[:sort_fields] = sort_fields

    redirect_to :action => 'list'
  end

  def choose_to_list
    @row_filter    = get_row_filter
    @column_filter = get_column_filter

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

  OFFENSIVE_ATTRIBUTES = 'offensive_attributes'
  DEFENSIVE_ATTRIBUTES = 'defensive_attributes'
  ALL_ATTRIBUTES = 'all_attributes'
  NO_ATTRIBUTES  = 'no_attributes'

  def filter_with_offensive_attributes
    filter_with_specified_attributes(OFFENSIVE_ATTRIBUTES)
  end
  def filter_with_defensive_attributes
    filter_with_specified_attributes(DEFENSIVE_ATTRIBUTES)
  end
  def filter_with_all_attributes
    filter_with_specified_attributes(ALL_ATTRIBUTES)
  end
  def filter_with_no_attributes
    filter_with_specified_attributes(NO_ATTRIBUTES)
  end

    def filter_with_specified_attributes(attributes)
      column_filter = get_column_filter
      case attributes
      when OFFENSIVE_ATTRIBUTES
        column_filter.set_offensive_attributes
      when DEFENSIVE_ATTRIBUTES
        column_filter.set_defensive_attributes
      else
        column_filter.set_all_or_no_attributes(attributes == ALL_ATTRIBUTES)
      end
      session[:column_filter] = column_filter

      redirect_to :action => 'list'
    end

  def show_attribute_legend
    @abbrs_with_full = PlayerAttribute.abbrs_with_full

    @page_title_size = 3
    @page_title = "Player Attribute Legend"
  end

  def depth_chart
    players = players_of_team
    @depth = Hash.new { |hash, key| hash[key] = Array.new }
    Position.find(:all).each do |position|
      players_at_position = players.select { |player| player.positions.include?(position) }
      players_at_position.each do |player|
        @depth[position] << player
      end
    end

    team = Team.find(session[:team_id])
    @page_title = "#{team.name} Depth Chart"
  end

  def roster_chart
    @error_explanation = session[:error_explanation]
    session[:error_explanation] = nil
    @players = players_of_team

    team = Team.find(session[:team_id])
    @page_title = "#{team.name} Roster Chart"
  end

  def edit_roster
    players = players_of_team
    commands = parse_roster_edit_command(params[:command], players)
    update_roster(commands, players) if commands

    redirect_to :action => 'roster_chart'
  end

  private

    def update_roster(commands, players)
      player1, action, player2 = commands
      begin
        Player.transaction do
          case action
          when 'with'
            exchange_player_order(player1, player2)
          when 'to'
            insert_player_order_before(player1, player2, players)
          else
            raise ActiveRecord::Rollback, "Unknown action '#{action}' in helper update_roster()"
          end
        end
      #rescue
        #explain_error("DB Error", ["Failed database transaction"], [])
      end
    end

    def exchange_player_order(player1, player2)
      n1 = player1.order_number
      n2 = player2.order_number
      player1.order_number = 999999
      player1.save!
      player2.order_number = n1
      player2.save!
      player1.order_number = n2
      player1.save!
    end

    def insert_player_order_before(player1, player2, players)
      index1 = players.index(player1)
      index2 = players.index(player2)
      return if index1 == index2
      if index1.nil? || index2.nil?
        names = Array.new
        names << player1.name if index1.nil?
        names << player2.name if index2.nil?
        raise ActiveRecord::Rollback, "Cannot find Player '#{names.join("', '")}' in 'players'"
      end

      player1 = players[index1]
      n_prev = player1.order_number
      player1.order_number = 999999
      player1.save!
      step = sgn(index2 - index1)
      (index1 + step).step(index2, step) do |index|
        player = players[index]
        n = player.order_number
        player.order_number = n_prev
        player.save!
        n_prev = n
      end
      player1.order_number = n_prev
      player1.save!
    end

    LEGAL_ACTIONS = %w(with to)

    def parse_roster_edit_command(command, players)
      if command.blank?
        explain_error("", ["No command specified"], [])
        return
      end

      title = "Command \"#{command}\" was illegal"
      terms = command.split
      if terms.size != 3
        explain_error(title, ["Command must be \"p# to/with p#\" (3 words)"], [])
        return
      end

      action = terms[1]
      unless LEGAL_ACTIONS.include?(action)
        legal_actions = "'" + LEGAL_ACTIONS.join("', '") + "'"
        explain_error(title, ["Legal actions are #{legal_actions}"], [])
        return
      end

      players = terms2players(terms, players, title)
      return unless players
      player1, player2 = players

      return [player1, action, player2]

      # for debug 
      msg = "#{player1.name} will be #{action=='to'?'inserted before':'exchanged with'} #{player2.name}"
      explain_error(title+" Not", [msg], [])
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

      num_starters = Constant.get(:num_starters)
      num_in_bench = Constant.get(:num_in_bench)
      return nil if kind == 's' && index > num_starters
      return nil if kind == 'b' && index > num_in_bench
      return nil if kind == 'r' && index > players.size - num_starters - num_in_bench
      player_index = index - 1
      player_index += num_starters unless kind == 's'
      player_index += num_in_bench if     kind == 'r'

      return players[player_index]
    end

    def sort_players(players, sort_fields)
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

    def players_of_team
      team_id = session[:team_id]
      raise "no 'team_id' in session" unless team_id
      return Player.list(team_id)
    end

    def prev_and_next_players(player)
      players = players_of_team
      index = players.index(player)
      return nil, nil unless index

      size = players.size
      prev_index = index == 0 ? size - 1 : index - 1
      next_index = index == size - 1 ? 0 : index + 1
      return [players[prev_index], players[next_index]]
    end
end

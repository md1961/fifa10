class PlayersController < ApplicationController

  def list
    team_id = 1
    @team = Team.find(team_id)

    @players = Player.find_all_by_team_id(@team.id)
    row_filter = get_row_filter
    @players = row_filter.displaying_players(@players)

    column_filter = get_column_filter
    @columns = column_filter.displaying_columns

    @page_title = "#{@team.name} Rosters"
  end

  def choose_to_list
    @row_filter    = get_row_filter
    @column_filter = get_column_filter

    @page_title = "Choose Items to Display"
  end

  def filter_on_list
    row_filter = get_row_filter(params)
    session[:row_filter] = row_filter

    column_filter = get_column_filter(params)
    session[:column_filter] = column_filter

    redirect_to :action => 'list'
  end

  def show_attribute_legend
    @abbrs_with_full = PlayerAttribute.abbrs_with_full

    @page_title = "Player Attribute Legend"
  end

  private

    def get_row_filter(params=nil)
      param = params ? params[:row_filter] : nil
      row_filter = param ? nil : session[:row_filter]
      row_filter = RowFilter.new(param) unless row_filter
      return row_filter
    end

    def get_column_filter(params=nil)
      param = params ? params[:column_filter] : nil
      column_filter = param ? nil : session[:column_filter]
      column_filter = ColumnFilter.new(param) unless column_filter
      return column_filter
    end
  

  class RowFilter
    POSITION_CATEGORIES = Position.categories.map { |c| c.downcase.intern }

    def self.pid2name(id)
      return "p#{id}"
    end
    
    # これはいんちき。チームが変わったらどうする？
    PLAYER_IDS = Player.find(:all).map { |p| pid2name(p.id).intern }

    INSTANCE_VARIABLE_NAMES = POSITION_CATEGORIES + PLAYER_IDS
    INSTANCE_VARIABLE_DEFAULT_VALUE = 1

    attr_accessor :option, *INSTANCE_VARIABLE_NAMES

    USE_POSITION_CATEGORIES = 1.to_s
    USE_POSITIONS           = 2.to_s
    USE_PLAYER_NAMES        = 3.to_s

    DEFAULT_OPTION = USE_POSITION_CATEGORIES

    def initialize(hash=nil)
      INSTANCE_VARIABLE_NAMES.each do |name|
        value = hash.nil? ? INSTANCE_VARIABLE_DEFAULT_VALUE : hash[name]
        instance_variable_set("@#{name}", value)
      end

      @option = hash ? hash[:option] || DEFAULT_OPTION : DEFAULT_OPTION
    end

    def self.instance_variable_names
      return INSTANCE_VARIABLE_NAMES
    end

    def self.position_categories
      return POSITION_CATEGORIES
    end

    def self.pid2id(pid)
      return pid.to_s[1..-1].to_i
    end

    def self.player_ids
      pids = PLAYER_IDS
      pids = pids.sort { |pid1, pid2|
        id1 = pid2id(pid1)
        id2 = pid2id(pid2)
        c1 = Player.find(id1).position.category
        c2 = Player.find(id2).position.category
        c_cmp = Position.compare_categories(c1, c2)
        c_cmp == 0 ? id1.<=>(id2) : c_cmp
      }
      return pids
    end

    def displaying_players(players)
      case @option
      when USE_POSITION_CATEGORIES
        categories = Position.categories
        categories = categories.select { |category| category_display?(category) }
        selected_players = players.select { |player| categories.include?(player.position.category) }

        players.each do |player|
          name = RowFilter.pid2name(player.id)
          instance_variable_set("@#{name}", selected_players.include?(player) ? '1' : '0')
        end
      when USE_POSITIONS
        selected_players = players
      when USE_PLAYER_NAMES
        selected_players = players.select do |player|
          name = RowFilter.pid2name(player.id)
          instance_variable_get("@#{name}") == '1'
        end
      else
        raise "Impossible!! Check the code."
      end
      return selected_players
    end

    private

      def category_display?(category)
        return instance_variable_get("@#{category.downcase}") == '1'
      end
  end

  class ColumnFilter
    PLAYER_PROPERTY_NAMES = [
      :first_name, :number, :position, :skill_move, :is_right_dominant,
      :both_feet_level, :height, :weight, :birth_year, :nation_id
    ]

    INSTANCE_VARIABLE_NAMES = PLAYER_PROPERTY_NAMES
    INSTANCE_VARIABLE_DEFAULT_VALUE = 1

    attr_accessor *INSTANCE_VARIABLE_NAMES

    COLUMN_NAMES_NOT_TO_DISPLAY = %w(id team_id)

    def initialize(hash=nil)
      INSTANCE_VARIABLE_NAMES.each do |name|
        value = hash.nil? ? INSTANCE_VARIABLE_DEFAULT_VALUE : hash[name]
        instance_variable_set("@#{name}", value)
      end
    end

    def self.instance_variable_names
      return INSTANCE_VARIABLE_NAMES
    end

    def displaying_columns
      columns = Player.columns
      columns = columns.select { |column| ! COLUMN_NAMES_NOT_TO_DISPLAY.include?(column.name) }
      columns = columns.select { |column| column_display?(column) }
      return columns
    end

    private

      def column_display?(column)
        return true unless INSTANCE_VARIABLE_NAMES.include?(column.name.intern)
        return instance_variable_get("@#{column.name}") == '1'
      end
  end
end

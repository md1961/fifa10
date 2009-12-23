class PlayersController < ApplicationController

  def list
    session[:team_id] = team_id = 1

    row_filter = get_row_filter
    @players = row_filter.displaying_players

    column_filter = get_column_filter
    @columns = column_filter.displaying_columns

    team = Team.find(team_id)
    @page_title = "#{team.name} Rosters"
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
      if columns == RECOMMENDED_COLUMNS
        column_filter = ColumnFilter.instance_with_recommended_columns
      else
        column_filter = ColumnFilter.instance_with_all_or_no_columns(columns == ALL_COLUMNS)
      end
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

      team_id = session[:team_id]
      raise "no 'team_id' in session" unless team_id
      row_filter.players = Player.list(team_id) if row_filter

      return row_filter
    end

    def get_column_filter(params=nil)
      param = params ? params[:column_filter] : nil
      column_filter = param ? nil : session[:column_filter]
      column_filter = ColumnFilter.new(param) unless column_filter
      return column_filter
    end
  

  class ColumnFilter
    YES = '1'
    NO  = '0'

    PLAYER_PROPERTY_NAMES = [
      :first_name, :number, :position_id, :skill_move, :is_right_dominant,
      :both_feet_level, :height, :weight, :birth_year, :nation_id
    ]

    INSTANCE_VARIABLE_NAMES = PLAYER_PROPERTY_NAMES
    INSTANCE_VARIABLE_DEFAULT_VALUE = YES

    attr_accessor *INSTANCE_VARIABLE_NAMES

    COLUMN_NAMES_NOT_TO_DISPLAY = %w(id team_id)

    def initialize(hash=nil)
      INSTANCE_VARIABLE_NAMES.each do |name|
        value = hash.nil? ? INSTANCE_VARIABLE_DEFAULT_VALUE : hash[name]
        instance_variable_set("@#{name}", value)
      end
    end

    def displaying_columns
      columns = Player.columns
      columns = columns.select { |column| ! COLUMN_NAMES_NOT_TO_DISPLAY.include?(column.name) }
      columns = columns.select { |column| column_display?(column) }
      return columns
    end

    RECOMMENDED_COLUMN_NAMES = [
      :position_id, :skill_move, :is_right_dominant, :both_feet_level, :height,
    ]

    def self.instance_with_recommended_columns
      hash = Hash.new { |k, v| k[v] = NO }
      PLAYER_PROPERTY_NAMES.each do |name|
        hash[name] = YES if RECOMMENDED_COLUMN_NAMES.include?(name)
      end
      return ColumnFilter.new(hash)
    end

    def self.instance_with_all_or_no_columns(all=true)
      value = all ? YES : NO
      return ColumnFilter.new(Hash.new { |k, v| k[v] = value })
    end

    private

      def column_display?(column)
        return true unless INSTANCE_VARIABLE_NAMES.include?(column.name.intern)
        return instance_variable_get("@#{column.name}") == YES
      end
  end
end

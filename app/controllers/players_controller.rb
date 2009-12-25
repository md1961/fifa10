class PlayersController < ApplicationController

  def list
    session[:team_id] = team_id = 1

    row_filter = get_row_filter
    @players = row_filter.displaying_players

    column_filter = get_column_filter
    @columns = column_filter.displaying_columns
    @attribute_columns = column_filter.displaying_attribute_columns

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
  ALL_ATTRIBUTES = 'all_attributes'
  NO_ATTRIBUTES  = 'no_attributes'

  def filter_with_offensive_attributes
    filter_with_specified_attributes(OFFENSIVE_ATTRIBUTES)
  end
  def filter_with_all_attributes
    filter_with_specified_attributes(ALL_ATTRIBUTES)
  end
  def filter_with_no_attributes
    filter_with_specified_attributes(NO_ATTRIBUTES)
  end

    def filter_with_specified_attributes(attributes)
      column_filter = get_column_filter
      if attributes == OFFENSIVE_ATTRIBUTES
        column_filter.set_offensive_attributes
      else
        column_filter.set_all_or_no_attributes(attributes == ALL_ATTRIBUTES)
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
end

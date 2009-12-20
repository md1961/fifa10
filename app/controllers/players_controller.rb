class PlayersController < ApplicationController
  include PlayersHelper

  def list
    team_id = 1
    @team = Team.find(team_id)

    @players = Player.find_all_by_team_id(team_id)
    column_filter = get_column_filter
    @columns = column_filter.displaying_columns

    @page_title = "#{@team.name} Rosters"
  end

  def choose_to_list
    @column_filter = get_column_filter

    @page_title = "Choose Items to Display"
  end

  def filter_on_list
    column_filter = get_column_filter(params)
    session[:column_filter] = column_filter

    redirect_to :action => 'list'
  end

  def show_attribute_legend
    @abbrs_with_full = PlayerAttribute.abbrs_with_full

    @page_title = "Player Attribute Legend"
  end

  private

    def get_column_filter(params=nil)
      param = params ? params[:column_filter] : nil
      column_filter = param ? nil : session[:column_filter]
      column_filter = classColumnFilter.new(param) unless column_filter
      return column_filter
    end
end

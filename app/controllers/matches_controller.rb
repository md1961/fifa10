class MatchesController < ApplicationController

  def list
    season_id = session[:season_id]
    @matches = Match.list(season_id)

    @page_title = "#{team_name_and_season_years} Fixtures and Results"
  end

  def new
    season_id = session[:season_id]
    @matches = Match.list(season_id)
    @match = Match.new

    @page_title_size = 3
    @page_title = "#{team_name_and_season_years} New Fixture/Result"
  end
end

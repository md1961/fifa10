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

  def create
    @match = make_match(params)
    if @match.save
      redirect_to :action => 'list'
    else
      season_id = session[:season_id]
      @matches = Match.list(season_id)
      render :action => 'new'
    end
  end

    def make_match(params)
      match = Match.new(params[:match])
      
      return match
    end
    private :make_match
end

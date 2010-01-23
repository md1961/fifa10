class MatchesController < ApplicationController

  def list
    season_id = session[:season_id]
    @matches = Match.list(season_id)

    @chronicle = Season.find(season_id).chronicle

    @page_title = "#{team_name_and_season_years} Fixtures and Results"
  end

  def new
    season_id = session[:season_id]
    @matches = Match.list(season_id)
    @match = Match.new

    prepare_page_title_for_new
  end

  def create
    @match = make_match(params)
    if @match.save
      redirect_to :action => 'list'
    else
      season_id = session[:season_id]
      @matches = Match.list(season_id)

      prepare_page_title_for_new
      render :action => 'new'
    end
  end

    def make_match(params)
      date_match = params[:match][:date_match]
      params[:match][:date_match] = '20' + date_match if date_match.to_i < 100
      match = Match.new(params[:match])
      match.season_id = session[:season_id]
      
      return match
    end
    private :make_match

    def prepare_page_title_for_new
      @page_title_size = 3
      @page_title = "#{team_name_and_season_years} New Fixture/Result"
    end
    private :prepare_page_title_for_new

  def edit
    season_id = session[:season_id]
    @matches = Match.list(season_id)
    @match = Match.find(params[:id])

    prepare_page_title_for_edit
  end

  def update
    @match = Match.find(params[:id])
    if @match.update_attributes(params[:match])
      redirect_to :action => 'list'
    else
      season_id = session[:season_id]
      @matches = Match.list(season_id)

      prepare_page_title_for_edit
      render :action => 'edit', :id => @match
    end
  end

    def prepare_page_title_for_edit
      @page_title_size = 3
      @page_title = "#{team_name_and_season_years} New Fixture/Result"
    end
    private :prepare_page_title_for_edit
end

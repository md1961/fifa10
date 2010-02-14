class MatchesController < ApplicationController

  def list
    season_id = get_and_save_season_id(params)

    @matches = get_matches(season_id)
    @chronicle = Season.find(season_id).chronicle
    @match_filter = get_match_filter

    @shows_link = true
    if shows_link = params[:shows_link]
      @shows_link = shows_link == '1'
    end

    @page_title_size = 3
    @page_title = "#{team_name_and_season_years} Fixtures and Results" \
                  + " <font size='-1'>(#{@chronicle.name})</font>"
  end

    def get_and_save_season_id(params)
      season_id = params[:season_id] || session[:season_id]
      season_id = season_id.to_i if season_id
      if season_id.nil? || season_id <= 0
        raise "No 'season_id' in params nor session (#{session.inspect})"
      end
      session[:season_id] = season_id
      return season_id
    end
    private :get_and_save_season_id

    def get_matches(season_id)
      matches = Match.list(season_id)
      match_filter = get_match_filter
      return match_filter.displaying_matches(matches)
    end
    private :get_matches

  def new
    season_id = session[:season_id]
    @matches = get_matches(season_id)
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
      adjust_date_match(params)

      match = Match.new(params[:match])
      match.season_id = session[:season_id]
      
      return match
    end
    private :make_match

    def adjust_date_match(params)
      date_match = params[:match][:date_match]
      if date_match.length <= 5
        month = date_match.to_i
        season = Season.find(session[:season_id])
        year = month >= Season::MONTH_START ? season.year_start : season.year_end
        params[:match][:date_match] = "#{year}/#{date_match}"
      elsif date_match.to_i < 100
        params[:match][:date_match] = '20' + date_match
      end
    end
    private :adjust_date_match

    def prepare_page_title_for_new
      @page_title_size = 3
      @page_title = "#{team_name_and_season_years} New Fixture/Result"
    end
    private :prepare_page_title_for_new

  def edit
    season_id = session[:season_id]
    @matches = get_matches(season_id)
    @match = Match.find(params[:id])

    prepare_page_title_for_edit
  end

  def update
    @match = Match.find(params[:id])
    adjust_date_match(params)
    if @match.update_attributes(params[:match])
      redirect_to :action => 'list'
    else
      season_id = session[:season_id]
      @matches = Match.list(season_id)

      prepare_page_title_for_edit
      render :action => 'edit', :id => @match
    end
  end

  def filter_with_series
    series_ids = params[:series_ids]

    log_debug "series_ids = #{series_ids.inspect}"

    match_filter = get_match_filter
    match_filter.reset_all_series
    match_filter.set_series_ids(series_ids)
    session[:match_filter] = match_filter

    redirect_to :action => 'list'
  end

  def choose_to_list
    @match_filter = get_match_filter

    @page_title_size = 3
    @page_title = "Specify conditions to filter"
  end

  def filter_on_list
    player_name_input = params[:match_filter][:player_name]
    player_name_input = nil if player_name_input.empty?
    match_filter = get_match_filter
    match_filter.player_name = player_name_input
    session[:match_filter] = match_filter

    redirect_to :action => 'list'
  end

  private

    def prepare_page_title_for_edit
      @page_title_size = 3
      @page_title = "#{team_name_and_season_years} New Fixture/Result"
    end

    def get_match_filter(params=nil)
      param = params ? params[:match_filter] : nil
      match_filter = param ? nil : session[:match_filter]
      match_filter = MatchFilter.new(param) unless match_filter
      session[:match_filter] = match_filter

      return match_filter
    end
end

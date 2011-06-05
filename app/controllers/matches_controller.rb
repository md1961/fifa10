class MatchesController < ApplicationController

  def index
    #TODO: use @season_id and do not store it in the session
    @season_id = get_and_save_season_id(params)

    @matches = get_matches(@season_id)
    @series = Season.find(@season_id).series
    @chronicle = Season.find(@season_id).chronicle

    @match_filter = get_match_filter
    next_match = Match.nexts(@season_id, 1)
    @match_filter.set_series(Series.friendly) if next_match && next_match.friendly?

    @team_abbr = team_abbr

    set_params(params)
    set_font_weight

    @shows_link_to_logout = true
    #TODO: introduce @page_sub_title
    @page_title_size = 3
    @page_title = "#{team_name_and_season_years} Fixtures and Results" \
                  + " <font size='-1'>(#{@chronicle.name})</font>"
  end

    def set_params(params)
      @shows_link = true
      if shows_link = params[:shows_link]
        @shows_link = shows_link == '1'
      end

      @shows_records = params[:shows_records] || session[:shows_records] || '1'
      session[:shows_records] = @shows_records
    end
    private :set_params

    def set_font_weight
      @is_font_bold = Constant.get(:default_is_font_bold_for_matches)
      @is_font_bold = session[:is_font_bold] unless session[:is_font_bold].nil?
      unless @is_font_bold
        @css_add = Array.new unless @css_add
        @css_add << 'table_match_font_normal'
      end
      session[:is_font_bold] = @is_font_bold
    end
    private :set_font_weight

  def set_font
    is_font_bold = params[:is_font_bold] || '1'
    session[:is_font_bold] = is_font_bold == '1'
    redirect_to matches_path
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
      matches = Match.by_season(season_id).order('date_match')
      match_filter = get_match_filter
      return match_filter.displaying_matches(matches)
    end
    private :get_matches

  def calendar
    @is_lineup = params[:is_lineup] == '1'

    @season_id = get_and_save_season_id(params)
    @matches = get_matches(@season_id)

    date_from_params = params[:date_start] && Date.parse(params[:date_start])
    next_match = Match.nexts(@season_id, 1)
    @date_start = date_from_params || next_match && next_match.date_match.beginning_of_month

    @leftmost_weekday  = 0

    @page_title_size = 3
    @page_title = "#{team_name_and_season_years} Match Calendar"
  end

  def new
    @season_id = session[:season_id]
    @matches = get_matches(@season_id)
    @match = Match.new
    @match.date_match = params[:date]
    premier = Series.premier
    season = Season.find(@season_id)
    @match.series = premier if season.series.include?(premier)
    @match.opponent_type = season.team_type

    @back_to = params[:back_to] && eval(params[:back_to])

    @team_abbr = team_abbr

    set_font_weight

    prepare_page_title_for_new
  end

  def create
    @match = make_match(params)
    @back_to = params[:back_to].blank? ? nil : params[:back_to]
    if @match.save
      redirect_to @back_to || matches_path
    else
      @season_id = session[:season_id]
      @matches = Match.by_season(@season_id).order('date_match')
      set_font_weight

      prepare_page_title_for_new
      render 'new'
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
    @season_id = session[:season_id]
    @matches = get_matches(@season_id)
    @match = Match.find(params[:id])
    @scores_only = params[:scores_only] == '1'

    @back_to = params[:back_to] && eval(params[:back_to])

    @team_abbr = team_abbr

    set_font_weight

    prepare_page_title_for_edit
  end

  def update
    @match = Match.find(params[:id])
    is_previously_played = @match.played?
    adjust_date_match(params)
    @back_to = params[:back_to].blank? ? nil : params[:back_to]
    if @match.update_attributes(params[:match])
      session[:ticket_to_examine_player_status_change] = true if @match.played? && ! is_previously_played
      redirect_to @back_to || matches_path
    else
      @season_id = session[:season_id]
      @matches = Match.by_season(@season_id).order('date_match')

      prepare_page_title_for_edit
      render 'edit', :id => @match
    end
  end

  def destroy
    Match.find(params[:id]).destroy
    back_to = params[:back_to].blank? ? nil : params[:back_to]

    redirect_to back_to || matches_path
  end

  def series_filter
    series_abbrs = params[:series_abbrs]

    match_filter = get_match_filter
    match_filter.reset_all_series
    match_filter.series_abbrs = series_abbrs
    session[:match_filter] = match_filter

    redirect_to matches_path
  end

  def player_choose
    @match_filter = get_match_filter

    @page_title_size = 3
    @page_title = "Specify conditions to filter"
  end

  def player_filter
    player_name_input = params[:match_filter][:player_name]
    player_name_input = nil if player_name_input.empty?
    match_filter = get_match_filter
    match_filter.player_name = player_name_input
    session[:match_filter] = match_filter

    redirect_to matches_path
  end

  private

    def prepare_page_title_for_edit
      @page_title_size = 3
      @page_title = "#{team_name_and_season_years} New Fixture/Result"
    end

    def get_match_filter(params=nil)
      param = params ? params[:match_filter] : nil
      match_filter = param ? nil : session[:match_filter]
      unless match_filter
        season_id = session[:season_id]
        season = Season.find(season_id)
        match_last_played = Match.last_played(season_id)
        includes_friendly = season.team_type == 'Nation' || (match_last_played && match_last_played.friendly?)
        match_filter = MatchFilter.new(param, includes_friendly)
      end
      session[:match_filter] = match_filter

      return match_filter
    end
end

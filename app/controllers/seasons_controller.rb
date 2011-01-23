class SeasonsController < ApplicationController

  def index
    @chronicle = Chronicle.find(params[:chronicle_id])
    @seasons   = Season.list(@chronicle)
    
    @page_title_size = 2
    @page_title = "Chronicle: #{@chronicle.name}"
  end

  DEFALUT_TEAM_TYPE = 'Team'
  TEAM_ORDER = 'name'
  INITIAL_SERIES_ABBRS = {
    'Team'   => ["CL", "Premier", "FA Cup", "L. Cup", "Friendly"],
    'Nation' => ["W. Cup Qlf.", "World Cup"         , "Friendly"],
  }

  def new
    @season = Season.new
    @season.team_type = team_type = params[:team_type] || DEFALUT_TEAM_TYPE
    @season.closed = false

    @chronicle_id = params[:chronicle_id]

    last_season = Chronicle.find(@chronicle_id).last_season
    if last_season
      @season.team_id    = last_season.team_id
      @season.year_start = last_season.year_start + 1
    end

    @teams = eval(team_type).find(:all, :order => TEAM_ORDER)
    @series = Series.find(:all)
    @initial_series_selection = INITIAL_SERIES_ABBRS[team_type].map do |abbr|
      Series.find_by_abbr(abbr)
    end

    prepare_page_title_for_new
  end

  def create
    @season = Season.new(params[:season])
    @season.series = series_selected(params)
    last_season = Chronicle.find(@season.chronicle_id).last_season
    @season.player_seasons = last_season.player_seasons
    if @season.save
      redirect_to seasons_path(:chronicle_id => @season.chronicle_id)
    else
      @teams = eval(@season.team_type).find(:all, :order => TEAM_ORDER)
      @series = Series.find(:all)
      @initial_series_selection = @season.series
      @chronicle_id = params[:season][:chronicle_id]

      prepare_page_title_for_new
      render :action => 'new'
    end
  end

    def series_selected(params)
      series_id_selected = params['series_ids'].select { |k, v| v == '1' }.map { |a| a[0] }
      return series_id_selected.map { |id| Series.find(id) }
    end
    private :series_selected

    def prepare_page_title_for_new
      @page_title_size = 3
      @page_title = "Creating a New Season"
    end
    private :prepare_page_title_for_new

  def edit
    @season = Season.find(params[:id])

    @chronicle_id = params[:chronicle_id]

    @teams = eval(@season.team_type).find(:all, :order => TEAM_ORDER)
    @series = Series.find(:all)
    @initial_series_selection = @season.series

    prepare_page_title_for_edit
  end

  def update
    @season = Season.find(params[:id])
    @season.attributes = params[:season]
    @season.series = series_selected(params)
    if @season.save
      redirect_to seasons_path(:chronicle_id => @season.chronicle_id)
    else
      prepare_page_title_for_edit
      @chronicle_id = params[:season][:chronicle_id]
      render :action => 'edit'
    end
  end

    def prepare_page_title_for_edit
      @page_title_size = 3
      @page_title = "Editing '#{@season.name_and_years}'"
    end
    private :prepare_page_title_for_edit
  
  def destroy
    season = Season.find(params[:id])
    if season.matches.empty?
      season.destroy
    end

    redirect_to seasons_path(:chronicle_id => params[:chronicle_id])
  end
end

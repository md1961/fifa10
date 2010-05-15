class SeasonsController < ApplicationController

  def list
    @chronicle_id = params[:chronicle_id]
    @seasons = Season.list(@chronicle_id)
    
    @page_title_size = 2
    @page_title = "Chronicle: #{Chronicle.find(@chronicle_id).name}"
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

    @teams = eval(team_type).find(:all, :order => TEAM_ORDER)
    @series = Series.find(:all)
    @initial_series_selection = INITIAL_SERIES_ABBRS[team_type].map do |abbr|
      Series.find_by_abbr(abbr)
    end

    @chronicle_id = params[:chronicle_id]

    prepare_page_title_for_new
  end

  def create
    @season = Season.new(params[:season])
    series_id_selected = params['series_ids'].select { |k, v| v == '1' }.map { |a| a[0] }
    @season.series = series_id_selected.map { |id| Series.find(id) }
    if @season.save
      redirect_to :action => 'list', :chronicle_id => @season.chronicle_id
    else
      prepare_page_title_for_new
      @chronicle_id = params[:season][:chronicle_id]
      render :action => 'new'
    end
  end

    def prepare_page_title_for_new
      @page_title_size = 3
      @page_title = "Creating a New Season"
    end
    private :prepare_page_title_for_new
end

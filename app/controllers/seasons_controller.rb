class SeasonsController < ApplicationController

  def list
    @chronicle_id = params[:chronicle_id]
    @seasons = Season.list(@chronicle_id)
    
    @page_title_size = 2
    @page_title = "Chronicle: #{Chronicle.find(@chronicle_id).name}"
  end

  def new
    @season = Season.new
    @season.closed = false
    @chronicle_id = params[:chronicle_id]

    prepare_page_title_for_new
  end

  def create
    @season = Season.new(params[:season])
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

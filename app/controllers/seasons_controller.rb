class SeasonsController < ApplicationController

  def list
    chronicle_id = params[:chronicle_id]
    @seasons = Season.list(chronicle_id)
    
    @page_title_size = 2
    @page_title = "Chronicle: #{Chronicle.find(chronicle_id).name}"
  end
end

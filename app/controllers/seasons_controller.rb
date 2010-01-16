class SeasonsController < ApplicationController

  def list
    chronicle_id = params[:chronicle_id]
    @seasons = Season.list(chronicle_id)
  end
end

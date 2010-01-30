class ChroniclesController < ApplicationController

  def index
    redirect_to :action => 'list'
  end

  def list
    @chronicles = Chronicle.find(:all)

    @page_title_size = 2
    @page_title = "Choose a Chronicle (Series of Seasons)"
  end
end

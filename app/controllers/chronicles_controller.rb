class ChroniclesController < ApplicationController

  def index
    redirect_to :action => 'list'
  end

  ORDER_BY = "name"

  def list
    @chronicles = Chronicle.find(:all, :order => ORDER_BY)

    @page_title_size = 2
    @page_title = "Choose a Chronicle (Series of Seasons)"
  end

  def new
    @chronicle = Chronicle.new

    prepare_page_title_for_new
  end

    def prepare_page_title_for_new
      @page_title_size = 3
      @page_title = "Creating a New Chronicle"
    end
    private :prepare_page_title_for_new

  def create
    @chronicle = Chronicle.new(params[:chronicle])
    if @chronicle.save
      redirect_to :action => 'list'
    else
      prepare_page_title_for_new
      render :action => 'new'
    end
  end
end

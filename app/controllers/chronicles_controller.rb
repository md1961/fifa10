class ChroniclesController < ApplicationController

  def index
    redirect_to :action => 'list'
  end

  SESSION_KEYS_TO_DELETE = [
    :match_filter,
  ]
  ORDER_BY = "closed, name"

  def list
    SESSION_KEYS_TO_DELETE.each do |key|
      session[key] = nil
    end

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

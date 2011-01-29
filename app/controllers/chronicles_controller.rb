class ChroniclesController < ApplicationController

  SESSION_KEYS_TO_DELETE = [
    :match_filter,
  ]
  ORDER_BY = "closed, name"

  def index
    SESSION_KEYS_TO_DELETE.each do |key|
      session[key] = nil
    end

    @chronicles = Chronicle.find(:all, :order => ORDER_BY)

    @page_title_size = 2
    @page_title = "Choose a Chronicle (Series of Seasons)"
  end

  def new
    @chronicle = Chronicle.new
    @example_names = Chronicle.find(:all).map(&:name).join('", "')

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
      redirect_to chronicles_path
    else
      prepare_page_title_for_new
      render 'new'
    end
  end

  def destroy
    Chronicle.find(params[:id]).destroy

    redirect_to chronicles_path
  end

  def open
    open_or_close(:open)
  end

  def close
    open_or_close(:close)
  end

    def open_or_close(action)
      chronicle = Chronicle.find(params[:id])
      chronicle.send(action)
      is_success = chronicle.save
      flash[:notice] = "Failed to #{action} Chronicle '#{chronicle.name}'" unless is_success
      redirect_to chronicles_path
    end
    private :open_or_close
end


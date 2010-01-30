class ChroniclesController < ApplicationController

  def index
    redirect_to :action => 'list'
  end

  def list
    @chronicles = Chronicle.find(:all)
  end
end

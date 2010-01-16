class ChroniclesController < ApplicationController

  def list
    @chronicles = Chronicle.find(:all)
  end
end

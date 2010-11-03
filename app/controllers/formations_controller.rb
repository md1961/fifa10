class FormationsController < ApplicationController

  def list
    @formations = Formation.find(:all, :order => "name")

    @page_title_size = 2
    @page_title = "Formations"
  end

  DEFAULT_POSITIONS = %w(GK RB CB CB LB RM CM CM LM RF LF)

  def new
    hash_args = Hash.new
    (1 .. 11).to_a.zip(DEFAULT_POSITIONS) do |index, position_name|
      position_id = Position.find_by_name(position_name).id
      column_name = (Formation.position_column_name(index)).intern
      hash_args[column_name] = position_id
    end

    @formation = Formation.new(hash_args)

    prepare_page_title_for_new
  end

    def prepare_page_title_for_new
      @page_title_size = 3
      @page_title = "Creating a New Formation"
    end
    private :prepare_page_title_for_new
    
  def create
    @formation = Formation.new(params[:formation])
    if @formation.save
      redirect_to :action => 'list'
    else
      prepare_page_title_for_new
      render :action => 'new'
    end
  end
end

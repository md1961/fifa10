class FormationsController < ApplicationController

  def index
    @is_lineup = params[:is_lineup] == '1'

    @formations = all_formations

    @page_title_size = 3
    @page_title = "Formations"
  end

    def all_formations
      return Formation.find(:all, :order => "name")
    end
    private :all_formations

  DEFAULT_POSITIONS = %w(GK RB CB CB LB RM CM CM LM RF LF)

  def new
    hash_args = Hash.new
    (1 .. 11).to_a.zip(DEFAULT_POSITIONS) do |index, position_name|
      position_id = Position.find_by_name(position_name).id
      column_name = (Formation.position_column_name(index)).intern
      hash_args[column_name] = position_id
    end

    @formation = Formation.new(hash_args)
    @formations = all_formations

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
      redirect_to formations_path
    else
      prepare_page_title_for_new
      render 'new'
    end
  end

  def edit
    @formation = Formation.find(params[:id])
    @formations = all_formations

    prepare_page_title_for_edit
  end

    def prepare_page_title_for_edit
      @page_title_size = 3
      @page_title = "Editing Formation #{@formation.name}"
    end
    private :prepare_page_title_for_edit

  def update
    @formation = Formation.find(params[:id])
    if @formation.update_attributes(params[:formation])
      redirect_to formations_path
    else
      prepare_page_title_for_edit
      render 'edit'
    end
  end

  def destroy
    Formation.find(params[:id]).destroy

    redirect_to formations_path
  end

  DIR_FORMATIONS = 'formations'
  DIR_IMAGES = File.join(Rails.root, 'public', 'images', DIR_FORMATIONS)

  def images
    @is_lineup = params[:is_lineup] == '1'

    @sources = Dir.entries(DIR_IMAGES).reject { |path| File.directory?(path) } \
                                      .map    { |path| File.join(DIR_FORMATIONS, path) }

    @index = params[:index] ? params[:index].to_i : 0

    @page_title = "Formation Images"
  end
end


class TeamsController < ApplicationController

  NAMES_NOT_TO_LIST = %w(TBD)
  CONDITIONS = "name != '#{NAMES_NOT_TO_LIST}'"
  ORDER = "nation_id, name"

  def list
    @teams = Team.find(:all, :conditions => CONDITIONS, :order => ORDER)
    @column_names = Team.columns.map(&:name)

    @page_title_size = 3
    @page_title = "Team List"
  end

  def new
    @team = Team.new

    prepare_for_new_or_edit(:new)
  end

  def create
    @team = Team.new(params[:team])
    #TODO: abbr = nil if no input
    if @team.save
      redirect_to :action => 'list'
    else
      prepare_for_new_or_edit(:new)
      render :action => 'new'
    end
  end

    def prepare_for_new_or_edit(action)
      @column_names = Team.columns.map(&:name) - %w(id)
      @nations = Nation.find(:all, :order => "name")

      @page_title_size = 3
      @page_title = action == :new ? "Creating a New Team..." : "Editing #{@team.name}..."
    end
    private :prepare_for_new_or_edit

  def edit
    @team = Team.find(params[:id])
    @column_names = Team.columns.map(&:name) - %w(id)
    @nations = Nation.find(:all, :order => "name")

    prepare_for_new_or_edit(:edit)
  end

  def update
    @team = Team.find(params[:id])
    if @team.update_attributes(params[:team])
      redirect_to :action => 'list'
    else
      prepare_for_new_or_edit(:edit)
      render :action => 'edit'
    end
  end
end

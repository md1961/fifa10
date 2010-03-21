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
    @column_names = Team.columns.map(&:name) - %w(id)
    @nations = Nation.find(:all, :order => "name")

    prepare_for_new
  end

  def create
    @team = Team.new(params[:team])
    if @team.save
      redirect_to :action => 'list'
    else
      prepare_for_new
      render :action => 'new'
    end
  end

    def prepare_for_new
      @page_title_size = 3
      @page_title = "Creating a New Team..."
    end
    private :prepare_for_new

  def edit
    @team = Team.find(params[:id])
    @column_names = Team.columns.map(&:name) - %w(id)
    @nations = Nation.find(:all, :order => "name")

    @page_title_size = 3
    @page_title = "Editing #{@team.name}..."
  end

  def update
  end
end

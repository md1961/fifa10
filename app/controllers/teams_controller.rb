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

    @page_title_size = 3
    @page_title = "Creating a New Team..."
  end

  def create
  end

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

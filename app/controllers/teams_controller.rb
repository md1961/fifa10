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
end

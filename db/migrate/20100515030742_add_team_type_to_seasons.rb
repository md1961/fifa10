class AddTeamTypeToSeasons < ActiveRecord::Migration
  def self.up
    add_column    :seasons, :team_type, :string, :default => 'Team', :null => false
  end

  def self.down
    remove_column :seasons, :team_type
  end
end

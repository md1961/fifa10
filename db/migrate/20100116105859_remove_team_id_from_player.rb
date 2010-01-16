class RemoveTeamIdFromPlayer < ActiveRecord::Migration
  def self.up
    remove_column :players, :team_id
  end

  def self.down
    add_column :players, :team_id, :integer, :null => false
  end
end

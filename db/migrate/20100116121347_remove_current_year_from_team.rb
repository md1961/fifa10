class RemoveCurrentYearFromTeam < ActiveRecord::Migration
  def self.up
    remove_column :teams, :current_year
  end

  def self.down
    add_column :teams, :current_year, :integer, :null => false
  end
end

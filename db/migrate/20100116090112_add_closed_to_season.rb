class AddClosedToSeason < ActiveRecord::Migration
  def self.up
    add_column :seasons, :closed, :boolean, :default => false
  end

  def self.down
    remove_column :seasons, :closed
  end
end

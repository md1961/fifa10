class AddIsNotWellToPlayerSeasons < ActiveRecord::Migration
  def self.up
    add_column    :player_seasons, :is_not_well, :boolean, :null => false, :default => false
  end

  def self.down
    remove_column :player_seasons, :is_not_well
  end
end

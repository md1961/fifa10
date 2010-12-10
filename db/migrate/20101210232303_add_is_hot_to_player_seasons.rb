class AddIsHotToPlayerSeasons < ActiveRecord::Migration
  def self.up
    add_column :player_seasons, :is_hot, :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :player_seasons, :is_hot
  end
end

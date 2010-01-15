require 'migration_helper'

class CreatePlayerSeasons < ActiveRecord::Migration
  extend MigrationHelper

  def self.up
    create_table :player_seasons do |t|
      t.integer :player_id, :null => false
      t.integer :season_id, :null => false
    end

    foreign_key :player_seasons, :player_id, :players
    foreign_key :player_seasons, :season_id, :seasons

    [
      [ 1,  1, 22],
      [ 1, 23, 38],
      [ 2,  1, 39],
    ].each do |season_id, min_player_id, max_player_id|
      (min_player_id .. max_player_id).each do |player_id|
        PlayerSeason.create(:player_id => player_id, :season_id => season_id)
      end
    end
  end

  def self.down
    drop_table :player_seasons
  end
end

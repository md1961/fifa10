require 'migration_helper'

class CreatePlayerSeasons < ActiveRecord::Migration
  extend MigrationHelper

    def self.order_number(player_id, season_id)
      return \
        case season_id
        when 2
          Player.find(player_id).order_number
        else
          player_id
        end
    end

  def self.up
    create_table :player_seasons do |t|
      t.integer :player_id   , :null => false
      t.integer :season_id   , :null => false
      t.integer :order_number, :null => false
    end

    foreign_key :player_seasons, :player_id, :players
    foreign_key :player_seasons, :season_id, :seasons

    [
      [ 1,  1, 22],
      [ 1, 23, 38],
      [ 2,  1, 39],
    ].each do |season_id, min_player_id, max_player_id|
      (min_player_id .. max_player_id).each do |player_id|
        order_number = CreatePlayerSeasons.order_number(player_id, season_id)
        PlayerSeason.create(:player_id => player_id, :season_id => season_id, :order_number => order_number)
      end
    end

    add_index :player_seasons, [:season_id, :order_number], :unique => true
  end

  def self.down
    drop_table :player_seasons
  end
end

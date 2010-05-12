require 'migration_helper'

class CreateSeasonSeries < ActiveRecord::Migration
  extend MigrationHelper

  def self.up
    create_table :season_series do |t|
      t.integer :season_id, :null => false
      t.integer :series_id, :null => false
    end

    foreign_key :season_series, :season_id, :seasons
    foreign_key :season_series, :series_id, :series

    season_ids = (1 .. 9).to_a - [6]
    series_ids = [1, 4, 5, 6, 7, 9]
    season_ids.each do |season_id|
      series_ids.each do |series_id|
        SeasonSeries.create(:season_id => season_id, :series_id => series_id)
      end
    end
  end

  def self.down
    drop_table :season_series
  end
end

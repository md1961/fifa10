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
  end

  def self.down
    drop_table :season_series
  end
end

require 'migration_helper'

class CreateMatches < ActiveRecord::Migration
  extend MigrationHelper

  def self.up
    create_table :matches do |t|
      t.date    :date_match
      t.integer :series_id
      t.string  :subname    , :null => false, :default => ""
      t.integer :opponent_id, :null => false
      t.string  :ground
      t.integer :scores_own                 , :default => nil
      t.integer :scores_opp                 , :default => nil
      t.integer :pks_own                    , :default => nil
      t.integer :pks_opp                    , :default => nil
      t.string  :scorers_own, :null => false, :default => ""
      t.string  :scorers_opp, :null => false, :default => ""
      t.integer :season_id  , :null => false
    end

    foreign_key :matches, :series_id  , :series
    foreign_key :matches, :opponent_id, :teams
    foreign_key :matches, :season_id  , :seasons
  end

  def self.down
    drop_table :matches
  end
end

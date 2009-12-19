class CreatePlayerAttributes < ActiveRecord::Migration
  def self.up
    create_table :player_attributes do |t|
      t.column :player_id     , :integer, :null => false
      t.column :acceleration  , :integer, :null => false
      t.column :positiveness  , :integer, :null => false
      t.column :quickness     , :integer, :null => false
      t.column :balance       , :integer, :null => false
      t.column :control       , :integer, :null => false
      t.column :cross         , :integer, :null => false
      t.column :curve         , :integer, :null => false
      t.column :dribble       , :integer, :null => false
      t.column :goalmaking    , :integer, :null => false
      t.column :fk_accuracy   , :integer, :null => false
      t.column :head_accuracy , :integer, :null => false
      t.column :jump          , :integer, :null => false
      t.column :long_pass     , :integer, :null => false
      t.column :long_shot     , :integer, :null => false
      t.column :mark          , :integer, :null => false
      t.column :pk            , :integer, :null => false
      t.column :positioning   , :integer, :null => false
      t.column :reaction      , :integer, :null => false
      t.column :short_pass    , :integer, :null => false
      t.column :shot_power    , :integer, :null => false
      t.column :sliding       , :integer, :null => false
      t.column :speed         , :integer, :null => false
      t.column :stamina       , :integer, :null => false
      t.column :tackle        , :integer, :null => false
      t.column :physical      , :integer, :null => false
      t.column :tactics       , :integer, :null => false
      t.column :vision        , :integer, :null => false
      t.column :volley        , :integer, :null => false
      t.column :gk_dive       , :integer, :null => false
      t.column :gk_handling   , :integer, :null => false
      t.column :gk_kick       , :integer, :null => false
      t.column :gk_positioning, :integer, :null => false
      t.column :gk_reaction   , :integer, :null => false
    end
  end

  def self.down
    drop_table :player_attributes
  end
end

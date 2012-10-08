require 'migration_helper'

class AddNationIdToTeam < ActiveRecord::Migration
  extend MigrationHelper

  def self.up
    add_column :teams, :nation_id, :integer, :null => false

    foreign_key :teams, :nation_id, :nations
  end

  def self.down
    remove_column :teams, :nation_id
  end
end

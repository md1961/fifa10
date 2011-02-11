require 'migration_helper'

class AddNationIdToTeam < ActiveRecord::Migration
  extend MigrationHelper

  def self.up
    add_column :teams, :nation_id, :integer, :null => false
    
    england_id = Nation.find_by_name('England').id
    Team.find(:all).each do |team|
      team.nation_id = england_id
      team.save
    end

    foreign_key :teams, :nation_id, :nations
  end

  def self.down
    remove_column :teams, :nation_id
  end
end

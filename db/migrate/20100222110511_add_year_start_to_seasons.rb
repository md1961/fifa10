class AddYearStartToSeasons < ActiveRecord::Migration
  def self.up
    add_column :seasons, :year_start, :integer, :null => false
  end

  def self.down
    remove_column :seasons, :year_start
  end
end

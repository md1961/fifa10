class RemoveYearsFromSeasons < ActiveRecord::Migration
  def self.up
    remove_column :seasons, :years
  end

  def self.down
    add_column :seasons, :years, :string
  end
end

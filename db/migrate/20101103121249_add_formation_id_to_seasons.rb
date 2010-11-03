class AddFormationIdToSeasons < ActiveRecord::Migration
  def self.up
    add_column    :seasons, :formation_id, :integer
  end

  def self.down
    remove_column :seasons, :formation_id
  end
end

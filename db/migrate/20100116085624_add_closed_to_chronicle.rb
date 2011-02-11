class AddClosedToChronicle < ActiveRecord::Migration
  def self.up
    add_column :chronicles, :closed, :boolean, :default => false
  end

  def self.down
    remove_column :chronicles, :closed
  end
end

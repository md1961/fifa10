class RemoveColumnOrderNumberFromPlayers < ActiveRecord::Migration
  def self.up
    remove_column :players, :order_number
  end

  def self.down
    add_column :players, :order_number, :integer
  end
end

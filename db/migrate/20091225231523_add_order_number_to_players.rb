class AddOrderNumberToPlayers < ActiveRecord::Migration
  def self.up
    add_column :players, :order_number, :integer, :null => false
  end

  def self.down
    remove_column :players, :order_number
  end
end

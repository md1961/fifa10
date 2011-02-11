class RemoveColumnOrderNumberFromPlayers < ActiveRecord::Migration
  def self.up
    remove_index  :players, [:team_id, :order_number]

    remove_column :players, :order_number
  end

  def self.down
    add_column :players, :order_number, :integer

    add_index  :players, [:team_id, :order_number], :unique => true
  end
end

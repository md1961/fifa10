class AddOverallAndValueToPlayers < ActiveRecord::Migration
  def self.up
    add_column :players, :overall     , :integer, :null => false
    add_column :players, :market_value, :integer
    add_column :players, :note        , :string
  end

  def self.down
    remove_column :players, :note
    remove_column :players, :market_value
    remove_column :players, :overall
  end
end

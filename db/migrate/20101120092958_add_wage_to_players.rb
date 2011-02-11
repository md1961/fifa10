class AddWageToPlayers < ActiveRecord::Migration
  def self.up
    add_column :players, :wage, :integer
  end

  def self.down
    remove_column :players, :wage
  end
end

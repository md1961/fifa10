class AddAgeAddInjToPlayers < ActiveRecord::Migration
  def self.up
    add_column    :players, :age_add_inj, :integer
  end

  def self.down
    remove_column :players, :age_add_inj
  end
end

class AddOnLoanToPlayerSeasons < ActiveRecord::Migration
  def self.up
    add_column :player_seasons, :on_loan, :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :player_seasons, :on_loan
  end
end

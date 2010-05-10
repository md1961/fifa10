class AddOpponentTypeToMatches < ActiveRecord::Migration
  def self.up
    add_column    :matches, :opponent_type, :string, :default => 'Team', :null => false
  end

  def self.down
    remove_column :matches, :opponent_type
  end
end

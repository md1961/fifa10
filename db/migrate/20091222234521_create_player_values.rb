class CreatePlayerValues < ActiveRecord::Migration
  def self.up
    create_table :player_values do |t|
      t.column :player_id, :integer, :null => false
      t.column :overall  , :integer, :null => false
      t.column :value    , :integer
      t.column :note     , :string
    end
  end

  def self.down
    drop_table :player_values
  end
end

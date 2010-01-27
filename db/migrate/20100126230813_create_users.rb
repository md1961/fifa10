class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string  :name           , :null => false
      t.string  :hashed_password
      t.string  :salt
      t.boolean :is_writer      , :null => false, :default => false
      t.boolean :is_admin       , :null => false, :default => false
      t.timestamps
    end

    add_index :users, :name, :unique => true
  end

  def self.down
    drop_table :users
  end
end

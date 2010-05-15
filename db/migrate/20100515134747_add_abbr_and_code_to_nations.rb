class AddAbbrAndCodeToNations < ActiveRecord::Migration
  def self.up
    rename_column :nations, :abbr, :code
    add_column    :nations, :abbr, :string, :default => nil
  end

  def self.down
    remove_column :nations, :abbr
    rename_column :nations, :code, :abbr
  end
end

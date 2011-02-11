class CreateFormations < ActiveRecord::Migration
  def self.up
    create_table :formations do |t|
      t.string  :name, :null => false
      t.string  :note
      1.upto(11) do |index|
        column_name = "position%02d_id" % index
        t.integer column_name.intern, :null => false
      end
    end

    add_index :formations, :name, :unique => true
  end

  def self.down
    drop_table :formations
  end
end

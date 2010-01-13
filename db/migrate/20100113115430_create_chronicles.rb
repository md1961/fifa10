class CreateChronicles < ActiveRecord::Migration
  def self.up
    create_table :chronicles do |t|
      t.string :name, :null => false
    end

    [
      "FIFA 10 Manager Mode",
    ].each do |name|
      Chronicle.create(:name => name)
    end
  end

  def self.down
    drop_table :chronicles
  end
end

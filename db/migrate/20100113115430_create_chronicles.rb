class CreateChronicles < ActiveRecord::Migration
  def self.up
    create_table :chronicles do |t|
      t.string :name, :null => false
    end

=begin
    [
      "FIFA 10 Manager Mode",
    ].each do |name|
      Chronicle.create(:name => name)
    end
=end
  end

  def self.down
    drop_table :chronicles
  end
end

class CreateRegions < ActiveRecord::Migration
  def self.up
    create_table :regions do |t|
      t.column :name, :string, :null => false
    end

=begin
    [
      'Europe', 'Africa', 'Asia', 'Oceania', 'North America', 'South America'
    ].each do |name|
      Region.create :name => name
    end
=end
  end

  def self.down
    drop_table :regions
  end
end

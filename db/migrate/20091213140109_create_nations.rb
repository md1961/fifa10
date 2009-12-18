class CreateNations < ActiveRecord::Migration
  def self.up
    create_table :nations do |t|
      t.column :name     , :string , :null => false
      t.column :region_id, :integer, :null => false
    end

    [
      ["Belgium"         , 1],
      ["Brazil"          , 6],
      ["Bulgaria"        , 1],
      ["England"         , 1],
      ["Equador"         , 6],
      ["France"          , 1],
      ["Germany"         , 1],
      ["Ireland"         , 1],
      ["Italy"           , 1],
      ["Korea"           , 3],
      ["Netherland"      , 1],
      ["Northern Ireland", 1],
      ["Norway"          , 1],
      ["Poland"          , 1],
      ["Portugal"        , 1],
      ["Scotland"        , 1],
      ["Serbia"          , 1],
      ["South Africa"    , 2],
      ["Wales"           , 1],
    ].each do |name, region_id|
      Nation.create :name => name, :region_id => region_id
    end
  end

  def self.down
    drop_table :nations
  end
end

class CreateSeasons < ActiveRecord::Migration
  def self.up
    create_table :seasons do |t|
      t.string  :years
      t.integer :chronicle_id
      t.integer :team_id
    end

    [
      ["2009-2010", 1, 1],
      ["2010-2011", 1, 1],
    ].each do |years, c_id, t_id|
      Season.create(:years => years, :chronicle_id => c_id, :team_id => t_id)
    end
  end

  def self.down
    drop_table :seasons
  end
end

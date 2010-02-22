class CreateSeasons < ActiveRecord::Migration
  def self.up
    create_table :seasons do |t|
      t.integer :year_start
      t.integer :chronicle_id
      t.integer :team_id
      t.boolean :closed
    end

    [
      [2009, 1, 1, true ],
      [2010, 1, 1, false],
      [2009, 2, 1, false],
    ].each do |year, c_id, t_id, closed|
      Season.create(:year_start => year, :chronicle_id => c_id, :team_id => t_id, :class => closed)
    end
  end

  def self.down
    drop_table :seasons
  end
end


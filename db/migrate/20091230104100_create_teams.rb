class CreateTeams < ActiveRecord::Migration
  def self.up
    create_table :teams do |t|
      t.column :name        , :string , :null => false
      t.column :year_founded, :integer
      t.column :ground      , :string
      t.column :current_year, :integer, :null => false
    end

=begin
    [
      ["Manchester United", 1878, "Old Trafford", 2010],
    ].each do |name, founded, ground, current|
      Team.create :name => name, :year_founded => founded, :ground => ground, :current_year => current
    end
=end
  end

  def self.down
    drop_table :teams
  end
end

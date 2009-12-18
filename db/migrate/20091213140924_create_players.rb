class CreatePlayers < ActiveRecord::Migration
  def self.up
    create_table :players do |t|
      t.column :name             , :string , :null => false
      t.column :first_name       , :string
      t.column :number           , :integer, :null => false
      t.column :position_id      , :integer, :null => false
      t.column :skill_move       , :integer, :null => false
      t.column :is_right_dominant, :boolean, :null => false
      t.column :both_feet_level  , :integer, :null => false
      t.column :height           , :integer, :null => false
      t.column :weight           , :integer, :null => false
      t.column :birth_year       , :integer, :null => false
      t.column :nation_id        , :integer, :null => false
      t.column :team_id          , :integer, :null => false
    end

    [
      ["Van Der Sar", "Edwin", 1, 1, 1, true, 3, 197, 89, 1971, 11],
      ["Neville", "Gary", 2, 4, 2, true, 3, 179, 79, 1975, 4],
      ["Ferdinand", "Rio", 5, 3, 2, true, 3, 192, 82, 1979, 4],
      ["Vidic", "Nemanja", 15, 3, 2, true, 3, 189, 84, 1982, 17],
      ["Evra", "Patrice", 3, 7, 2, false, 2, 175, 76, 1981, 6],
      ["Vanlencia", "Antonio, Luis", 25, 13, 4, true, 4, 181, 73, 1985, 5],
      ["Scholes", "Paul", 18, 9, 3, true, 3, 170, 74, 1975, 4],
      ["Carrick", "Michael", 16, 9, 3, true, 4, 185, 74, 1981, 4],
      ["Giggs", "Ryan", 11, 11, 5, false, 3, 180, 70, 1974, 19],
      ["Rooney", "Wayne", 10, 15, 5, true, 4, 177, 79, 1986, 4],
      ["Berbatov", "Dimitar", 9, 18, 5, true, 3, 189, 80, 1981, 3],
      ["Owen", "Michael", 7, 18, 3, true, 4, 173, 70, 1980, 4],
      ["Nani", "", 17, 14, 5, true, 4, 175, 66, 1987, 15],
      ["Fletcher", "Darren", 24, 9, 3, true, 3, 184, 83, 1984, 11],
      ["Hargreaves", "Owen", 4, 8, 2, true, 4, 180, 73, 1981, 4],
      ["O'Shea", "John", 22, 4, 2, true, 3, 190, 75, 1981, 8],
      ["J. Evans", "Jonny", 23, 3, 2, true, 3, 188, 77, 1988, 18],
      ["Foster", "Ben", 12, 1, 1, false, 2, 188, 80, 1983, 4],
      ["Anderson", "", 8, 9, 5, false, 3, 176, 69, 1988, 2],
      ["Park", "Ji Sung", 13, 10, 5, true, 3, 175, 70, 1981, 15],
      ["Welbeck", "Danny", 19, 15, 4, true, 3, 185, 73, 1991, 4],
      ["Macheda", "Federico", 27, 18, 2, true, 3, 184, 77, 1992, 9],
      ["Mabe", "Thembinkosi", 32, 14, 3, false, 3, 170, 65, 1991, 18],
      ["Rafael", "Da Silva", 21, 6, 4, true, 4, 172, 69, 1990, 2],
      ["Brown", "Wes", 6, 3, 2, true, 3, 185, 75, 1980, 4],
      ["Fabio", "Da Silva", 20, 7, 4, true, 3, 172, 69, 1990, 2],
      ["Kuszczak", "Tomasz", 29, 1, 1, true, 2, 190, 84, 1982, 14],
      ["Gibson", "Darron", 28, 9, 2, true, 4, 183, 80, 1988, 8],
      ["Tosic", "Zoran", 14, 11, 2, false, 3, 171, 69, 1987, 17],
      ["Obertan", "Gabriel", 26, 13, 5, true, 4, 186, 80, 1989, 6],
      ["Cathcart", "Craig", 37, 3, 2, true, 2, 188, 73, 1989, 18],
      ["De Laet", "Ritchie", 30, 3, 2, true, 4, 188, 76, 1989, 1],
      ["Eikrem", "Magnus Wolff", 51, 9, 2, true, 3, 179, 69, 1990, 13],
      ["Zieler", "Ron-Robert", 38, 1, 1, true, 2, 188, 77, 1989, 7],
      ["Hewson", "Sam", 33, 9, 2, true, 2, 180, 81, 1989, 4],
      ["C. Evans", "Corry", 31, 8, 2, true, 3, 181, 74, 1990, 18],
      ["Bryan", "Antonio", 50, 18, 2, true, 3, 180, 75, 1990, 4],
      ["James", "Matthew", 47, 9, 2, true, 3, 175, 75, 1991, 4],
    ].each do |name, fname, number, pos_id, skill, is_right, both_level, height, weight, birth_year, nation_id|
      Player.create :name => name, :first_name => fname, :number => number, :position_id => pos_id, \
                    :skill_move => skill, :is_right_dominant => is_right, :both_feet_level => both_level, \
                    :height => height, :weight => weight, :birth_year => birth_year, :nation_id => nation_id, \
                    :team_id => 1
    end
  end

  def self.down
    drop_table :players
  end
end

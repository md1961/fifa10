class CreatePlayerPositions < ActiveRecord::Migration
  def self.up
    create_table :player_positions do |t|
      t.column :player_id  , :integer, :null => false
      t.column :position_id, :integer, :null => false
    end

=begin
    [
      [ 2,  3], [ 2,  6], [ 3,  8], [ 3,  2], [ 4,  8], [ 5,  5], [ 5, 11], [ 6, 10], [ 6, 12], [ 6, 15],
      [ 7, 12], [ 7, 15], [ 8,  8], [ 8, 12], [ 9,  9], [ 9, 12], [ 9, 14], [10, 18], [10, 14], [10, 17],
      [11, 15], [12, 17], [12, 15], [13, 13], [13, 11], [13, 10], [14, 10], [14,  8], [14,  4], [15,  9],
      [15, 10], [15,  6], [16,  8], [16,  5], [16,  3], [17,  4], [17,  5], [19, 12], [19, 11], [19,  8],
      [20, 11], [20, 12], [20,  9], [21, 18], [21, 13], [21, 14], [22, 15], [22, 14], [23, 11], [23, 17],
      [24,  4], [24, 13], [24,  7], [25,  4], [26,  5], [26, 11], [26,  4], [28,  8], [28, 10], [29, 14],
      [29, 12], [29, 10], [30, 14], [30, 10], [31,  4], [32,  4], [32,  5], [33, 10], [33, 11], [35, 12],
      [36,  9], [36,  3], [36,  4], [37, 15], [38, 10], [38,  4], [38,  6],
    ].each do |player_id, position_id|
      PlayerPosition.create :player_id => player_id, :position_id => position_id
    end
=end
  end

  def self.down
    drop_table :player_positions
  end
end

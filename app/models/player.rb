class Player < ActiveRecord::Base
  belongs_to :nation
  belongs_to :team
  belongs_to :position
  has_many :player_positions
  has_many :sub_positions, :through => :player_positions, :source => :position
  has_one :player_attribute

  ORDER_WHEN_LIST = "order_number"

  def self.list(team_id)
    return find_all_by_team_id(team_id, :order => ORDER_WHEN_LIST)
  end

  def positions
    return [position] + sub_positions
  end
end

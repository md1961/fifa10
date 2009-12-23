class Player < ActiveRecord::Base
  belongs_to :nation
  belongs_to :team
  belongs_to :position
  has_many :player_positions
  has_many :positions, :through => :player_positions
  has_one :player_value
  has_one :player_attribute
end

class Season < ActiveRecord::Base
  belongs_to :chronicle
  belongs_to :team
  has_many :player_seasons
  has_many :players, :through => :player_seasons
end

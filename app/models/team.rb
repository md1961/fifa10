class Team < ActiveRecord::Base
  has_many :seasons
  has_many :players
end

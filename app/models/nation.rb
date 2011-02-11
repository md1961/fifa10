class Nation < ActiveRecord::Base
  belongs_to :region
  has_many :players
  has_many :teams
end

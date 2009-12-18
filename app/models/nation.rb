class Nation < ActiveRecord::Base
  belongs_to :region
  has_many :players
end

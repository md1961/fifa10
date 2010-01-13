class Season < ActiveRecord::Base
  belongs_to :chronicle
  belongs_to :team
end

class Match < ActiveRecord::Base
  belongs_to :series
  belongs_to :opponent, :class_name => 'Team', :foreign_key => 'opponent_id'
  belongs_to :season
end

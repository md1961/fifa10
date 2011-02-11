class SeasonSeries < ActiveRecord::Base
  belongs_to :season
  belongs_to :series
end

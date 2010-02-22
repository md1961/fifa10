class Season < ActiveRecord::Base
  belongs_to :chronicle
  belongs_to :team
  has_many :player_seasons
  has_many :players, :through => :player_seasons

  #TODO: many-to-many with Series thru TABLE SeasonSeries

  MONTH_START = 7

  def self.list(chronicle_id)
    seasons = find_all_by_chronicle_id(chronicle_id)
    return seasons.sort.reverse
  end

  def year_end
    return year_start + 1
  end

  def years
    return "#{year_start}-#{year_end}"
  end

  def <=>(other)
    return self.year_start.<=>(other.year_start)
  end
end

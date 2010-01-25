class Season < ActiveRecord::Base
  belongs_to :chronicle
  belongs_to :team
  has_many :player_seasons
  has_many :players, :through => :player_seasons

  #TODO: many-to-many with Series thru TABLE SeasonSeries

  MONTH_START = 7

  def self.list(chronicle_id)
    seasons = find_all_by_chronicle_id(chronicle_id)
    seasons.sort!
    return seasons
  end

  def year_start
    return years[0, years.index('-')].to_i
  end

  def year_end
    return years[years.index('-') + 1, years.length].to_i
  end

  def <=>(other)
    return self.year_start.<=>(other.year_start)
  end
end

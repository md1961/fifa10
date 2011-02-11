class Series < ActiveRecord::Base
  has_many :season_series
  has_many :season, :through => :season_series

  ABBR_FOR_PREMIER = 'Premier'

  def self.premier
    return find_by_abbr(ABBR_FOR_PREMIER)
  end

  LEAGUE_ABBRS = ["Premier", "W. Cup Qlf.", "World Cup"]

  def league?
    return LEAGUE_ABBRS.include?(abbr)
  end

  def premier?
    return abbr == 'Premier'
  end

  def world_cup_final?
    return name == "World Cup"
  end

  def friendly?
    return abbr == 'Friendly'
  end
end

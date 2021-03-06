class Series < ActiveRecord::Base
  has_many :season_series
  has_many :season, :through => :season_series

  ABBR_FOR_PREMIER  = 'Premier'
  ABBR_FOR_CL       = 'CL'
  ABBR_FOR_FRIENDLY = 'Friendly'

  def self.premier
    return find_by_abbr(ABBR_FOR_PREMIER)
  end

  def self.friendly
    return find_by_abbr(ABBR_FOR_FRIENDLY)
  end

  LEAGUE_ABBRS = ["Premier", "Championship", "W. Cup Qlf.", "World Cup"]

  def league?
    return LEAGUE_ABBRS.include?(abbr)
  end

  def premier?
    return abbr == ABBR_FOR_PREMIER
  end

  def champions_leaque?
    return abbr == ABBR_FOR_CL
  end

  def world_cup_final?
    return name == "World Cup"
  end

  def friendly?
    return abbr == ABBR_FOR_FRIENDLY
  end
end

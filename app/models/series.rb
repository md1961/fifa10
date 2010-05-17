class Series < ActiveRecord::Base
  has_many :season_series
  has_many :season, :through => :season_series

  #TODO: Delete
  def self.premier_all
    hash_order = {
      # abbr    order in list
      'Premier'    => 1,
      'FA Cup'     => 2,
      'L. Cup'     => 3,
      'CL'         => 4,
      #'EL'    => 5,
      'UEFA SC'    => 6,
      'C. Shield'  => 7,
      'Friendly'   => 8,
    }
    series = find(:all, :conditions => ["abbr in (?)", hash_order.keys])
    series.sort! { |s1, s2| hash_order[s1.abbr].<=>(hash_order[s2.abbr]) }
    return series
  end

  #TODO: Delete
  def self.premier_all_but_friendly
    return premier_all.select { |s| s.abbr != 'Friendly' }
  end

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

  def friendly?
    return abbr == 'Friendly'
  end
end

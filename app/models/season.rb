class Season < ActiveRecord::Base
  belongs_to :chronicle
  belongs_to :team
  has_many :player_seasons
  has_many :players, :through => :player_seasons

  def self.list(chronicle_id)
    seasons = find_all_by_chronicle_id(chronicle_id)
    seasons.sort!
    return seasons
  end

  def year_start
    return years[0, years.index('-')].to_i
  end

  def <=>(other)
    return self.year_start.<=>(other.year_start)
  end
end

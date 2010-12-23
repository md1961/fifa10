class Chronicle < ActiveRecord::Base
  has_many :seasons

  def last_season
    return nil if seasons.size == 0
    seasons_sorted = seasons.sort { |s1, s2|
      s1.year_start.<=>(s2.year_start)
    }
    return seasons_sorted[0]
  end

  def open
    self.closed = false
  end

  def close
    self.closed = true
  end
end

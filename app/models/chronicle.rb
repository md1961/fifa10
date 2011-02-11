class Chronicle < ActiveRecord::Base
  has_many :seasons

  validates_uniqueness_of :name

  def last_season
    return seasons.sort_by { |season| season.year_start }.last
  end

  def open
    self.closed = false
  end

  def close
    self.closed = true
  end
end

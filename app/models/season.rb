class Season < ActiveRecord::Base
  belongs_to :chronicle
  belongs_to :team
  has_many :player_seasons
  has_many :players, :through => :player_seasons

  def year_start
    return years[0, years.index('-')].to_i
  end
end

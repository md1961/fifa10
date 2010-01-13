class Team < ActiveRecord::Base
  has_many :seasons
  has_many :players

  def name_and_year
    return "#{name} #{current_year}"
  end
end

class Match < ActiveRecord::Base
  belongs_to :series
  belongs_to :opponent, :class_name => 'Team', :foreign_key => 'opponent_id'
  belongs_to :season

  def self.list(season_id)
    return find_all_by_season_id(season_id, :order => 'date_match')
  end

  def result
    diff = scores_own - scores_opp
    diff = pks_own - pks_opp if pks_own
    if diff > 0
      return 'W'
    elsif diff < 0
      return 'L'
    end
    return pks_own ? '?' : 'D'
  end
end

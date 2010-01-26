class Match < ActiveRecord::Base
  belongs_to :series
  belongs_to :opponent, :class_name => 'Team', :foreign_key => 'opponent_id'
  belongs_to :season

  GROUNDS = %w(H A N).freeze

  validates_presence_of :date_match, :series_id, :opponent_id, :ground, :season_id
  validates_inclusion_of :ground, :in => GROUNDS
  validates_numericality_of :scores_own, :only_integer => true, :greater_than_or_equal_to => 0, :allow_nil => true
  validates_numericality_of :scores_opp, :only_integer => true, :greater_than_or_equal_to => 0, :allow_nil => true
  validates_numericality_of :pks_own   , :only_integer => true, :greater_than_or_equal_to => 0, :allow_nil => true
  validates_numericality_of :pks_opp   , :only_integer => true, :greater_than_or_equal_to => 0, :allow_nil => true
  #:date_match, :series_id, :subname, :opponent_id, :ground, :scores_own, :scores_opp, :pks_own, :pks_opp, :scorers_own, :scorers_opp, :season_id

  def self.list(season_id)
    return find_all_by_season_id(season_id, :order => 'date_match')
  end

  def self.grounds
    return GROUNDS
  end

  WIN  = 'win_in_match'
  LOSE = 'lose_in_match'
  DRAW = 'draw_in_match'
  UNKNOWN_RESULT = 'unknown_result_in_match'

  def win?
    return result == WIN
  end

  def lose?
    return result == LOSE
  end

  def draw?
    return result == DRAW
  end

  private

    def result
      diff = scores_own - scores_opp
      diff = pks_own - pks_opp if pks_own
      if diff > 0
        return WIN
      elsif diff < 0
        return LOSE
      end
      return pks_own ? UNKNOWN_RESULT : DRAW
    end
end

class Match < ActiveRecord::Base
  belongs_to :series
  belongs_to :opponent, :polymorphic => true
  belongs_to :season

  GROUNDS = %w(H A N).freeze

  validates_presence_of :date_match, :series_id, :opponent_id, :ground, :season_id
  validates_inclusion_of :ground, :in => GROUNDS
  validates_numericality_of :scores_own, :only_integer => true, :greater_than_or_equal_to => 0, :allow_nil => true
  validates_numericality_of :scores_opp, :only_integer => true, :greater_than_or_equal_to => 0, :allow_nil => true
  validates_numericality_of :pks_own   , :only_integer => true, :greater_than_or_equal_to => 0, :allow_nil => true
  validates_numericality_of :pks_opp   , :only_integer => true, :greater_than_or_equal_to => 0, :allow_nil => true
  #:date_match, :series_id, :subname, :opponent_id, :ground, :scores_own, :scores_opp, :pks_own, :pks_opp, :scorers_own, :scorers_opp, :season_id

  def self.list(season_id, order='date_match')
    return find_all_by_season_id(season_id, :order => order)
  end

  def self.last_played(season_id)
    matches = Match.list(season_id, 'date_match DESC')
    return matches.find { |match| match.played? }
  end

  def self.grounds
    return GROUNDS
  end

  def played?
    return scores_own.kind_of?(Fixnum) && scores_opp.kind_of?(Fixnum)
  end

  def friendly?
    return series.friendly?
  end

  def world_cup_final_knockout?
    return series.world_cup_final? && (/Group/i =~ subname).nil?
  end

  WIN   = :win
  LOSE  = :lose
  DRAW  = :draw
  NOT_PLAYED = :not_played
  UNKNOWN_RESULT = :unknown_result
  POINT = :point

  def win?
    return result == WIN
  end

  def lose?
    return result == LOSE
  end

  def draw?
    return result == DRAW
  end

  POINT_FOR_WIN  = 3
  POINT_FOR_DRAW = 1

  def record
    return {} unless played?
    matches_so_far = Match.find_all_by_season_id_and_series_id(season_id, series_id,
                             :conditions => ["date_match <= ?", date_match], :order => 'date_match')
    h_record = Hash.new { |h, k| h[k] = 0 }
    h_record = matches_so_far.inject(h_record) do |h_record, match|
      h_record[match.send(:result)] += 1
      h_record
    end
    h_record[POINT] = h_record[WIN] * POINT_FOR_WIN + h_record[DRAW] * POINT_FOR_DRAW
    return h_record
  end

  def to_s
    s = "#{date_match} vs #{opponent.name}"
    s += scores_own ? " #{scores_own}-#{scores_opp}" : " (TBP)"
    return s
  end

  private

    def result
      return NOT_PLAYED unless played?
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

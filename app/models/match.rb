class Match < ActiveRecord::Base
  belongs_to :series
  belongs_to :opponent, :polymorphic => true
  belongs_to :season

  GROUNDS = [
    ['Home'   , 'H'],
    ['Away'   , 'A'],
    ['Neutral', 'N'],
  ].freeze
  GROUND_ABBRS = GROUNDS.map { |entry| entry[1] }

  validates_presence_of :date_match, :series_id, :opponent_id, :ground, :season_id
  validates_inclusion_of :ground, :in => GROUND_ABBRS
  validates_numericality_of :scores_own, :only_integer => true, :greater_than_or_equal_to => 0, :allow_nil => true
  validates_numericality_of :scores_opp, :only_integer => true, :greater_than_or_equal_to => 0, :allow_nil => true
  validates_numericality_of :pks_own   , :only_integer => true, :greater_than_or_equal_to => 0, :allow_nil => true
  validates_numericality_of :pks_opp   , :only_integer => true, :greater_than_or_equal_to => 0, :allow_nil => true

  scope :by_season, lambda { |season_id| where(:season_id => season_id) }

  def self.list(season_id, order='date_match')
    return by_season(season_id).order(order)
  end

  def self.last_played(season_id)
    matches = Match.list(season_id, 'date_match DESC')
    return matches.find { |match| match.played? }
  end

  def self.nexts(season_id)
    matches = Match.list(season_id, 'date_match')
    next_match = matches.find { |match| ! match.played? }
    return Array.new unless next_match
    index = matches.index(next_match)
    return matches[index .. -1]
  end

  def self.recent_form(num_matches, season_id)
  end

  def self.grounds
    return GROUND_ABBRS
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

  ONE_CHAR_RESULT_NOT_PLAYED = '-'

  def one_char_result
    return played? ? result[0].upcase : ONE_CHAR_RESULT_NOT_PLAYED
  end

  def home?
    return ground == 'H'
  end

  def away?
    return ground == 'A'
  end

  def full_ground
    return Hash[*GROUNDS.map { |x, y| [y, x] }.flatten][ground]
  end

  POINT_FOR_WIN  = 3
  POINT_FOR_DRAW = 1

  def record
    return {} unless played?
    matches_so_far = Match.find_all_by_season_id_and_series_id(season_id, series_id,
                             :conditions => ["date_match <= ?", date_match], :order => 'date_match')
    if /Stage \d+/ =~ self.subname
      stage = $&
      matches_so_far = matches_so_far.select { |m| /#{stage}/ =~ m.subname }
    end
    h_record = Hash.new { |h, k| h[k] = 0 }
    h_record = matches_so_far.inject(h_record) do |h_record, match|
      h_record[match.send(:result)] += 1
      h_record
    end
    h_record[POINT] = h_record[WIN] * POINT_FOR_WIN + h_record[DRAW] * POINT_FOR_DRAW
    return h_record
  end

  def to_s
    series_full  = series.abbr
    series_full += " #{subname}" unless subname.blank?
    s  = "#{date_match} #{date_match.strftime("%a.")} [#{series_full}] vs #{opponent.name} (#{full_ground})"
    s += " #{scores_own}-#{scores_opp}" if scores_own
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

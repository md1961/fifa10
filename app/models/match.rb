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
  validate :scorers_own_should_be_in_rosters

  scope :by_season  , lambda { |season_id|   where(:season_id   => season_id   ) }
  scope :by_opponent, lambda { |opponent_id| where(:opponent_id => opponent_id ) }
  scope :by_series  , lambda { |series_id|   where(:series_id   => series_id   ) }
  scope :before     , lambda { |date_match|  where("date_match < ?", date_match) }

  def self.list(season_id, order='date_match')
    return by_season(season_id).order(order)
  end

  def self.last_played(season_id, is_league=false)
    matches = by_season(season_id).order('date_match DESC')
    return matches.find { |match| match.played? && (! is_league || match.league?) }
  end

  def self.nexts(season_id, num_matches=nil)
    matches = by_season(season_id).order('date_match')
    next_match = matches.find { |match| ! match.played? }
    unless next_match
      matches = Array.new
    else
      index = matches.index(next_match)
      matches = matches[index .. -1]
      matches = matches.first(num_matches) if num_matches
    end

    return num_matches == 1 ? matches.first : matches
  end

  def self.recent_form(num_matches, season_id, series_id=nil)
    matches = by_season(season_id).order('date_match DESC')
    matches = matches.by_series(series_id) if series_id
    matches.reject! { |match| ! match.played? }

    return matches.reverse.last(num_matches).map(&:one_char_result).join(' ')
  end

  def self.recent_meetings(opponent_id, num_matches, season_id)
    matches = Array.new
    Season.find(season_id).chronicle.seasons.each do |season|
      matches.concat(by_opponent(opponent_id).by_season(season.id))
    end
    matches.sort_by! { |match| match.date_match }
    matches.reverse!
    matches.select! { |match| match.played? }

    return matches.first(num_matches)
  end

  def self.grounds
    return GROUND_ABBRS
  end

  def self.in_transfer_window?(date)
    return Constant.get(:months_of_transfer_windows).include?(date.month)
  end

  def played?
    return scores_own.kind_of?(Fixnum) && scores_opp.kind_of?(Fixnum)
  end

  def league?
    return series.league?
  end

  def friendly?
    return series.friendly?
  end

  def world_cup_final_knockout?
    return series.world_cup_final? && (/Group/i =~ subname).nil?
  end

  RE_LEG2 = /(leg\s*)2/i

  def leg2?
    return (subname =~ RE_LEG2).present?
  end

  def leg1
    return nil unless leg2?

    matches = Match.by_season(season_id).by_series(series_id).by_opponent(opponent_id)
    re_leg1 = /#{subname.sub(RE_LEG2) { $1 + '\\s*1' }}/i
    match_leg1 = matches.select { |match| match.subname =~ re_leg1 }.last

    return match_leg1
  end

  def aggregate_score
    return "" unless leg2?
    return "#{leg1.scores_own + scores_own}-#{leg1.scores_opp + scores_opp}"
  end

  def match_number
    return Match.by_season(season_id).by_series(series_id).before(date_match).count + 1
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

  def result_and_score
    return "" unless scores_own
    return "#{one_char_result} #{scores_own}-#{scores_opp}"
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

  RE_PARENTHESIS_NOT_CLOSED = /\([^)]*$/
  RE_PARENTHESIS_NOT_OPENED = /^[^(]*\)/
  RE_SCORER = /^\s*([A-Z][A-Za-z. ]+)\s+(\d.*)\s*$/

  # Return a Hash with keys of player names and values of scoring times
  def interpret_scorers_own
    scorers_with_time = Array.new
    _scorers = scorers_own.split(',')
    _scorers.each_with_index do |scorer, index|
      scorer_prev = _scorers[index - 1]
      if scorer_prev && scorer_prev =~ RE_PARENTHESIS_NOT_CLOSED && scorer =~ RE_PARENTHESIS_NOT_OPENED
        scorers_with_time[scorers_with_time.size - 1] += ',' + scorer
      else
        scorers_with_time << scorer
      end
    end

    hash_scorers = Hash.new
    scorers_with_time.each do |scorer|
      hash_scorers[$1] = $2 if scorer =~ RE_SCORER
    end

    return hash_scorers
  end

  def scorers_display
    strs = Array.new
    [
      ["F: ", scorers_own], 
      ["A: ", scorers_opp], 
    ].each { |index, scorers|
      strs << index + scorers if scorers.present? 
    }
    
    return strs.join(', ')
  end

  def to_s
    series_full  = series && series.abbr
    series_full += " #{subname}" unless subname.blank?
    series_full += " ##{match_number}" if league?
    day_of_week = date_match && date_match.strftime("%a.")
    opponent_name = opponent && opponent.name
    s  = "#{date_match} #{day_of_week} [#{series_full}] #{opponent_name} (#{full_ground}) #{result_and_score}"

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

    def scorers_own_should_be_in_rosters
      player_names = Player.list(season, includes_on_loan=false).map(&:name)
      scorers_not_in_rosters = interpret_scorers_own.keys.reject { |scorer| player_names.include?(scorer) }
      errors.add(:scores_own, "#{scorers_not_in_rosters.join(', ')} not in rosters") unless scorers_not_in_rosters.empty?
    end
end

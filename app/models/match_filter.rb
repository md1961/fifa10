class MatchFilter

  YES = '1'
  NO  = '0'

  ALL_SERIES = 'All'
  DEFAULT_SERIES_ABBRS = ALL_SERIES

  def self.abbr2attr_name(abbr)
    # Substitute spaces with '_', then remove periods.
    return abbr.gsub(/\s+/, '_').gsub(/\./, '').downcase
  end

  SERIES_NAMES = Series.find(:all).map { |s| abbr2attr_name(s.abbr) }

  INSTANCE_VARIABLE_NAMES = SERIES_NAMES
  INSTANCE_VARIABLE_DEFAULT_VALUE = YES

  attr_accessor *INSTANCE_VARIABLE_NAMES
  attr_accessor :player_name

  def initialize(hash=nil, includes_friendly=false)
    unless hash
      hash = Hash.new { |h, k| h[k] = INSTANCE_VARIABLE_DEFAULT_VALUE }
      hash['friendly'] = includes_friendly ? YES : NO
    end
    INSTANCE_VARIABLE_NAMES.each do |name|
      instance_variable_set("@#{name}", hash[name])
    end
    @player_name = nil
    @series_abbrs = [DEFAULT_SERIES_ABBRS]
  end

  def selected_series(season_id)
    season = Season.find(season_id)
    return season.series.select do |series|
      attr_name = MatchFilter.abbr2attr_name(series.abbr)
      instance_variable_get("@#{attr_name}") == YES
    end
  end

  def reset_all_series
    SERIES_NAMES.each do |name|
      instance_variable_set("@#{name}", NO)
    end
  end

  def set_series(series, value=YES)
    attr_name = MatchFilter.abbr2attr_name(series.abbr)
    instance_variable_set("@#{attr_name}", value)
  end

  def series_abbrs
    return @series_abbrs
  end

  def series_abbrs=(series_abbrs)
    series_abbrs = [series_abbrs] if series_abbrs.kind_of?(String)
    series_ids = Array.new
    series_abbrs.each do |series_abbr|
      if series_abbr == ALL_SERIES
        #TODO: This is a magic word.
        series_ids.concat(Series.premier_all_but_friendly.map(&:id))
      else
        series_ids << Series.find_by_abbr(series_abbr).id
      end
    end
    @series_abbrs = series_abbrs
    set_series_ids(series_ids)
  end

    def set_series_ids(series_ids)
      series_ids.each do |series_id|
        series = Series.find(series_id)
        set_series(series, YES)
      end
    end
    private :set_series_ids

  def displaying_matches(matches)
    new_matches = matches.select do |match|
      attr_name = MatchFilter.abbr2attr_name(match.series.abbr)
      instance_variable_get("@#{attr_name}") == YES
    end

    #TODO: Match not only scores but opponent team name 
    if @player_name
      re = Regexp.compile(@player_name, Regexp::IGNORECASE)
      new_matches = new_matches.select do |match|
        re =~ match.scorers_own || re =~ match.opponent.name
      end
    end

    return new_matches
  end
end


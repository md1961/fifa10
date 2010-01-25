class MatchFilter

  YES = '1'
  NO  = '0'

  def self.abbr2attr_name(abbr)
    # Substitute spaces with '_', then remove periods.
    return abbr.gsub(/\s+/, '_').gsub(/\./, '').downcase
  end

  SERIES_NAMES = Series.find(:all).map { |s| abbr2attr_name(s.abbr) }

  INSTANCE_VARIABLE_NAMES = SERIES_NAMES
  INSTANCE_VARIABLE_DEFAULT_VALUE = YES

  attr_accessor *INSTANCE_VARIABLE_NAMES
  attr_accessor :player_name

  def initialize(hash=nil)
    INSTANCE_VARIABLE_NAMES.each do |name|
      value = hash.nil? ? INSTANCE_VARIABLE_DEFAULT_VALUE : hash[name]
      instance_variable_set("@#{name}", value)
    end
    @player_name = nil
  end

  def selected_series
    # TODO: Series.premier_all is magic word.  Introduce SeasonSeries.
    return Series.premier_all.select do |series|
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

  def set_series_ids(series_ids)
    series_ids.each do |series_id|
      series = Series.find(series_id)
      set_series(series, YES)
    end
  end

  def displaying_matches(matches)
    new_matches = matches.select do |match|
      attr_name = MatchFilter.abbr2attr_name(match.series.abbr)
      instance_variable_get("@#{attr_name}") == YES
    end

    if @player_name
      new_matches = new_matches.select do |match|
        /#{@player_name}/i =~ match.scorers_own
      end
    end

    return new_matches
  end
end


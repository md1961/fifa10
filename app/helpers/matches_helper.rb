module MatchesHelper

  COLUMN_NAMES_FOR_LIST = %w(
    date_match series_id ground opponent_id scores_own scorers_own scorers_opp pks_own
  ).freeze

  def column_names_for_list
    return COLUMN_NAMES_FOR_LIST
  end

  HASH_COLUMN_INDEX = {
    :date_match  => 'Date',
    :series_id   => 'Series',
    :opponent_id => 'Opponent',
    :ground      => 'G',
    :scores_own  => 'Score',
    :scorers_own => 'Scores Own',
    :scorers_opp => 'Scores Opp.',
    :pks_own     => 'PK',
  }

  def column_heading(column_name)
    return HASH_COLUMN_INDEX[column_name.intern] || ''
  end

  def series_for_collection_select(season_id)
    #TODO: When editing, need to return all the possible series to select.
    match_filter = session[:match_filter]
    return match_filter.selected_series(season_id)
  end

  def teams_for_collection_select
    season_id = session[:season_id]
    season = Season.find(season_id)
    own_team  = season.team
    team_type = season.team_type
    team_class = eval(team_type)

    tbd = team_class.find_by_name('TBD')
    opponent_teams = team_class.find(:all, :conditions => ["id not in (?)", [own_team.id, tbd.id]], :order => 'name')

    direction_at_first = Team.new(:name => 'Choose a team', :id => 0) 
    return [direction_at_first, tbd] + opponent_teams
  end

  def grounds_for_select
    return [['Choose' , '0']] + Match::GROUNDS
  end

  RECORD_NOT_PLAYED = "-"

  def record_display(match)
    return RECORD_NOT_PLAYED unless match.played? && match.series.league?
    return RECORD_NOT_PLAYED if match.world_cup_final_knockout?
    h_record = match.record
    wins   = h_record[Match::WIN ]
    draws  = h_record[Match::DRAW]
    loses  = h_record[Match::LOSE]
    points = h_record[Match::POINT]
    games  = wins + draws + loses
    return "G#{games}-P#{points}-W#{wins}-D#{draws}-L#{loses}"
  end

  def link_to_series_filter(abbr, current_abbr)
    param = abbr == MatchFilter::ALL_SERIES ? abbr : [abbr]
    param << MatchFilter::ALL_SERIES if param == ['Friendly']
    is_current = abbr == current_abbr
    label = is_current ? bold(abbr) : abbr
    return link_to_unless is_current, label, series_filter_matches_path(:series_abbrs => param)
  end

  def make_dates_for_calendar(date_start, num_months)
    date_end = date_start.months_since(num_months - 1).end_of_month
    dates = (date_start .. date_end).to_a

    date_cursor = dates.first
    until date_cursor.wday == @leftmost_weekday
      date_cursor = date_cursor.yesterday
      dates.unshift(date_cursor)
    end

    rightmost_weekday = @leftmost_weekday == 0 ? 6 : @leftmost_weekday - 1
    date_cursor = dates.last
    until date_cursor.wday == rightmost_weekday
      date_cursor = date_cursor.tomorrow
      dates << date_cursor
    end

    return dates
  end

  def html_class_for_day_of_week(date)
    case date.wday
    when 0, 6
      'weekend'
    else
      'weekday'
    end
  end

  def match_td_in_calendar(date, shows_month=false)
    date_display = date.day.to_s
    date_display = "#{date.month}/" + date_display if shows_month

    match = @matches.find { |match| match.date_match == date }

    htmls = Array.new

    h_params = {:id => match, :date => date, :back_to => 'calendar_matches_path'}
    htmls << link_to(date_display, match ? edit_match_path(h_params) : new_match_path(h_params))

    unless match
      htmls.concat(['&nbsp;'] * 4)
      clazz = ''
    else
      result = match.result_and_score
      result = '&nbsp' if result.strip.blank?
      htmls << [match.series.abbr, match.subname].join(' ')
      htmls << "<b>#{match.opponent.abbr_name}</b>"
      htmls << match.full_ground
      htmls << result
      clazz = match.win? ? 'win' : match.lose? ? 'lose' : match.draw? ? 'draw' : ''
    end

    return content_tag(:td, htmls.join('<br />').html_safe, :class => "match #{clazz}")
  end
end


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

  GROUNDS = [
    ['Choose' , '0'],
    ['Home'   , 'H'],
    ['Away'   , 'A'],
    ['Neutral', 'N'],
  ]

  def grounds_for_select
    return GROUNDS
  end

  def one_char_result(match)
    return match.win? ? 'W' : match.lose? ? 'L' : match.draw? ? 'D' : '?'
  end

  RECORD_NOT_PLAYED = "-"

  def record_display(match)
    return RECORD_NOT_PLAYED unless match.played? && match.series.premier?
    h_record = match.record
    wins   = h_record[Match::WIN ]
    draws  = h_record[Match::DRAW]
    loses  = h_record[Match::LOSE]
    points = h_record[Match::POINT]
    games  = wins + draws + loses
    return "G#{games}-P#{points}-W#{wins}-D#{draws}-L#{loses}"
  end

  def link_to_filter_with_series(abbr, current_abbr)
    param = abbr == MatchFilter::ALL_SERIES ? abbr : [abbr]
    param << MatchFilter::ALL_SERIES if param == ['Friendly']
    is_current = abbr == current_abbr
    label = is_current ? "<b>#{abbr}</b>" : abbr
    return link_to_unless is_current, label, :action => 'filter_with_series', :series_abbrs => param
  end
end

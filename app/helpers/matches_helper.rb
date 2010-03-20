module MatchesHelper

  COLUMN_NAMES_FOR_LIST = %w(
    date_match series_id ground opponent_id scores_own scorers_own scorers_opp pks_own
  ).freeze

  def column_names_for_list
    return COLUMN_NAMES_FOR_LIST
  end

  HASH_TEXT_FIELD_SIZE = {
    :date_match  => 10,
    :ground      =>  2,
    :scorers_own => 60,
    :scorers_opp => 40,
  }
  DEFAULT_TEXT_FIELD_SIZE = 8

  def text_field_size(column_name)
    return HASH_TEXT_FIELD_SIZE[column_name.intern] || DEFAULT_TEXT_FIELD_SIZE
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

  def series_for_collection_select
    #TODO: When editing, need to return all the possible series to select.
    match_filter = session[:match_filter]
    return match_filter.selected_series
  end

  def teams_for_collection_select
    season_id = session[:season_id]
    own_team = Season.find(season_id).team
    tbd = Team.find_by_name('TBD')
    opponent_teams = Team.find(:all, :conditions => ["id not in (?)", [own_team.id, tbd.id]], :order => 'name')

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
end

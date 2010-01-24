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
    :scorers_own => 20,
    :scorers_opp => 20,
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
end

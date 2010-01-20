module MatchesHelper

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
end

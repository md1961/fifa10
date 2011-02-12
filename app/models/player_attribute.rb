class PlayerAttribute < ActiveRecord::Base

  def self.fulls
    return ABBRS.map { |pair| pair[0] }
  end

  def self.abbrs
    return ABBRS.map { |pair| pair[1] }
  end

  def self.abbrs_with_full
    return ABBRS.map { |pair| [pair[1], pair[0].to_s] }
  end

  def self.abbr(column_name)
    entry = ABBRS.find { |name, abbr| name.to_s == column_name.to_s }
    return entry ? entry[1] : nil
  end

  def self.zeros
    obj = new
    content_columns.each do |column|
      obj[column.name] = 0
    end
    return obj
  end

  def all_zero?
    content_column_names = PlayerAttribute.content_columns.map(&:name)
    column_values = content_column_names.map { |name| attributes[name] }
    return column_values.all? { |value| value == 0 }
  end

  ABBRS = [
    [:acceleration   , 'AC'],
    [:positiveness   , 'PV'],
    [:quickness      , 'QK'],
    [:balance        , 'BL'],
    [:control        , 'CO'],
    [:cross          , 'CR'],
    [:curve          , 'CU'],
    [:dribble        , 'DR'],
    [:goalmaking     , 'GM'],
    [:fk_accuracy    , 'FK'],
    [:head_accuracy  , 'HA'],
    [:jump           , 'JP'],
    [:long_pass      , 'LP'],
    [:long_shot      , 'LS'],
    [:mark           , 'MK'],
    [:pk             , 'PK'],
    [:positioning    , 'PS'],
    [:reaction       , 'RC'],
    [:short_pass     , 'SP'],
    [:shot_power     , 'PW'],
    [:sliding        , 'SL'],
    [:speed          , 'SD'],
    [:stamina        , 'ST'],
    [:tackle         , 'TK'],
    [:physical       , 'PH'],
    [:tactics        , 'TC'],
    [:vision         , 'VS'],
    [:volley         , 'VL'],
    [:gk_dive        , 'GD'],
    [:gk_handling    , 'GH'],
    [:gk_kick        , 'GK'],
    [:gk_positioning , 'GP'],
    [:gk_reaction    , 'GR'],
  ].freeze
end

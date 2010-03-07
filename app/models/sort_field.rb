class SortField

  PLAYER_PROPERTY_NAMES = [
    :number, :skill_move, :both_feet_level, :height, :weight, :birth_year, :overall, :market_value
  ]

  PLAYER_ATTRIBUTE_COLUMNS = PlayerAttribute.content_columns
  PLAYER_ATTRIBUTE_NAMES = PLAYER_ATTRIBUTE_COLUMNS.map { |column| column.name.intern }

  NAMES = [:none] + PLAYER_PROPERTY_NAMES + PLAYER_ATTRIBUTE_NAMES

  ASCENDING  = '0'
  DESCENDING = '1'
  DEFAULT_ASCENDING = DESCENDING

  attr_accessor :ascending

  def initialize(name=:none, ascending=DEFAULT_ASCENDING)
    @name = name
    @ascending = ascending
  end

  FIELD_NAMES_AT_EOL = [:market_value, :jump, :tackle]

  def self.names_for_display
    names = Array.new
    NAMES.each do |name|
      names << name
      names << nil if FIELD_NAMES_AT_EOL.include?(name)
    end

    return names
  end

  def name
    return @name
  end
  def name=(name)
    name = name.intern if name.kind_of?(String)
    unless NAMES.include?(name)
      raise ArgumentError.new("Unknown field name '#{name}'")
    end

    @name = name
  end

  def ascending?
    return @ascending == ASCENDING
  end

end

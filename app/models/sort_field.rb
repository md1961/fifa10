class SortField

  PLAYER_PROPERTY_NAMES = [
    :number, :skill_move, :both_feet_level, :height, :weight, :birth_year, :overall, :market_value
  ]

  PLAYER_ATTRIBUTE_COLUMNS = PlayerAttribute.content_columns
  PLAYER_ATTRIBUTE_NAMES = PLAYER_ATTRIBUTE_COLUMNS.map { |column| column.name.intern }

  SORT_FIELD_NAMES = [:none] + PLAYER_PROPERTY_NAMES + PLAYER_ATTRIBUTE_NAMES

  DEFAULT_ASCENDING = true

  def initialize(field_name=:none, ascending=DEFAULT_ASCENDING)
    unless [true, false].include?(ascending)
      raise ArgumentError.new("Argument ascending must be a boolean ('#{ascending}' given)")
    end

    @field_name = field_name
    @ascending = ascending
  end

  def field_name
    return @field_name
  end
  def field_name=(name)
    name = name.intern if name.kind_of?(String)
    unless SORT_FIELD_NAMES.include?(name)
      raise ArgumentError.new("Unknown field name '#{name}'")
    end

    @field_name = name
  end

  def ascending?
    return @ascending
  end
  def set_ascending
    @ascending = true
  end
  def set_descending
    @ascending = false
  end

end

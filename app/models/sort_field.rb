class SortField

  PLAYER_PROPERTY_NAMES = [
    :number, :skill_move, :both_feet_level, :height, :weight, :birth_year, :overall, :market_value
  ]

  PLAYER_ATTRIBUTE_COLUMNS = PlayerAttribute.content_columns
  PLAYER_ATTRIBUTE_NAMES = PLAYER_ATTRIBUTE_COLUMNS.map { |column| column.name.intern }

  FIELD_NAMES = [:none] + PLAYER_PROPERTY_NAMES + PLAYER_ATTRIBUTE_NAMES

  DEFAULT_ASCENDING = '1'

  attr_accessor :ascending

  def initialize(field_name=:none, ascending=DEFAULT_ASCENDING)
    @field_name = field_name
    @ascending = ascending
  end

  FIELD_NAMES_AT_EOL = [:market_value, :jump, :tackle]

  def self.field_names_for_display
    field_names = Array.new
    FIELD_NAMES.each do |name|
      field_names << name
      field_names << nil if FIELD_NAMES_AT_EOL.include?(name)
    end

    return field_names
  end

  def field_name
    return @field_name
  end
  def field_name=(name)
    name = name.intern if name.kind_of?(String)
    unless FIELD_NAMES.include?(name)
      raise ArgumentError.new("Unknown field name '#{name}'")
    end

    @field_name = name
  end

  def ascending?
    return @ascending == '1'
  end

end

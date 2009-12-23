class ColumnFilter

  YES = '1'
  NO  = '0'

  PLAYER_PROPERTY_NAMES = [
    :first_name, :number, :position_id, :skill_move, :is_right_dominant,
    :both_feet_level, :height, :weight, :birth_year, :nation_id
  ]

  PLAYER_ATTRIBUTE_COLUMNS = PlayerAttribute.content_columns
  PLAYER_ATTRIBUTE_NAMES = PLAYER_ATTRIBUTE_COLUMNS.map { |column| column.name.intern }

  INSTANCE_VARIABLE_NAMES = PLAYER_PROPERTY_NAMES + PLAYER_ATTRIBUTE_NAMES
  INSTANCE_VARIABLE_DEFAULT_VALUE = YES

  attr_accessor *INSTANCE_VARIABLE_NAMES

  COLUMN_NAMES_NOT_TO_DISPLAY = %w(id team_id)

  def initialize(hash=nil)
    INSTANCE_VARIABLE_NAMES.each do |name|
      value = hash.nil? ? INSTANCE_VARIABLE_DEFAULT_VALUE : hash[name]
      instance_variable_set("@#{name}", value)
    end
  end

  def displaying_columns
    columns = Player.columns
    columns = columns.select { |column| ! COLUMN_NAMES_NOT_TO_DISPLAY.include?(column.name) }
    columns = columns.select { |column| column_display?(column) }
    return columns
  end

  def displaying_attribute_columns
    return PLAYER_ATTRIBUTE_COLUMNS.select { |column| instance_variable_get("@#{column.name}") == YES }
  end

  RECOMMENDED_COLUMN_NAMES = [
    :position_id, :skill_move, :is_right_dominant, :both_feet_level, :height,
  ]

  def self.instance_with_recommended_columns
    hash = Hash.new { |k, v| k[v] = NO }
    PLAYER_PROPERTY_NAMES.each do |name|
      hash[name] = YES if RECOMMENDED_COLUMN_NAMES.include?(name)
    end
    return ColumnFilter.new(hash)
  end

  def self.instance_with_all_or_no_columns(all=true)
    value = all ? YES : NO
    return ColumnFilter.new(Hash.new { |k, v| k[v] = value })
  end

  private

    def column_display?(column)
      return true unless INSTANCE_VARIABLE_NAMES.include?(column.name.intern)
      return instance_variable_get("@#{column.name}") == YES
    end
end


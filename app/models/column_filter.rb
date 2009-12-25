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

  def set_recommended_columns
    PLAYER_PROPERTY_NAMES.each do |name|
      instance_variable_set("@#{name}", RECOMMENDED_COLUMN_NAMES.include?(name) ? YES : NO)
    end
  end
  def set_all_or_no_columns(all=true)
    value = all ? YES : NO
    PLAYER_PROPERTY_NAMES.each do |name|
      instance_variable_set("@#{name}", value)
    end
  end

  GENERAL_ATTRIBUTE_NAMES_1   = [:acceleration, :positiveness, :quickness, :balance, :jump, :positioning]
  GENERAL_ATTRIBUTE_NAMES_2   = [:reaction, :speed, :stamina, :physical, :tactics, :vision]
  OFFENSIVE_ATTRIBUTE_NAMES_1 = [:control, :cross, :curve, :dribble, :goalmaking, :fk_accuracy, :head_accuracy]
  OFFENSIVE_ATTRIBUTE_NAMES_2 = [:long_pass, :long_shot, :pk, :short_pass, :shot_power, :volley]
  DEFENSIVE_ATTRIBUTE_NAMES   = [:mark, :sliding, :tackle]
  GOALKEEPING_ATTRIBUTE_NAMES = [:gk_dive, :gk_handling, :gk_kick, :gk_positioning, :gk_reaction]

  GENERAL_ATTRIBUTE_NAMES = GENERAL_ATTRIBUTE_NAMES_1 + GENERAL_ATTRIBUTE_NAMES_2
  OFFENSIVE_ATTRIBUTE_NAMES = OFFENSIVE_ATTRIBUTE_NAMES_1 + OFFENSIVE_ATTRIBUTE_NAMES_2

  def set_offensive_attributes
    set_specified_attributes(OFFENSIVE_ATTRIBUTE_NAMES)
  end
  def set_defensive_attributes
    set_specified_attributes(DEFENSIVE_ATTRIBUTE_NAMES + GENERAL_ATTRIBUTE_NAMES)
  end
    def set_specified_attributes(attribute_names)
      PLAYER_ATTRIBUTE_NAMES.each do |name|
        instance_variable_set("@#{name}", attribute_names.include?(name) ? YES : NO)
      end
    end
    private :set_specified_attributes
  def set_all_or_no_attributes(all=true)
    value = all ? YES : NO
    PLAYER_ATTRIBUTE_NAMES.each do |name|
      instance_variable_set("@#{name}", value)
    end
  end

  private

    def column_display?(column)
      return true unless INSTANCE_VARIABLE_NAMES.include?(column.name.intern)
      return instance_variable_get("@#{column.name}") == YES
    end
end


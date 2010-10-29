class ColumnFilter

  YES = '1'
  NO  = '0'

  COLUMN_NAMES_NOT_TO_FILTER = [:id, :name, :order_number, :note]

  # To create this, use the following statement:
  # PLAYER_PROPERTY_NAMES = Player.columns.map { |c| c.name.intern }.select { |n| ! COLUMN_NAMES_NOT_TO_FILTER.include?(n) }
  PLAYER_PROPERTY_NAMES = [:first_name, :number, :position_id, :skill_move, :is_right_dominant, :both_feet_level,
                           :height, :weight, :birth_year, :nation_id, :overall, :market_value]

  PLAYER_ATTRIBUTE_COLUMNS = PlayerAttribute.content_columns
  PLAYER_ATTRIBUTE_NAMES = PLAYER_ATTRIBUTE_COLUMNS.map { |column| column.name.intern }

  INSTANCE_VARIABLE_NAMES = PLAYER_PROPERTY_NAMES + PLAYER_ATTRIBUTE_NAMES
  INSTANCE_VARIABLE_DEFAULT_VALUE = YES

  attr_accessor *INSTANCE_VARIABLE_NAMES

  def initialize(hash=nil)
    INSTANCE_VARIABLE_NAMES.each do |name|
      value = hash.nil? ? INSTANCE_VARIABLE_DEFAULT_VALUE : hash[name]
      instance_variable_set("@#{name}", value)
    end

    @no_attributes = false
  end

  #TODO: To be removed(?)
  COLUMN_NAMES_NOT_TO_DISPLAY = %w(id order_number)

  COLUMN_NAMES_TO_DISPLAY = %w(name first_name number position_id birth_year height weight
            nation_id is_right_dominant both_feet_level skill_move overall market_value)

  def self.displaying_columns
    return Player.columns.select { |column| ! COLUMN_NAMES_NOT_TO_DISPLAY.include?(column.name) }
  end

  def displaying_columns
    columns = ColumnFilter.displaying_columns.select { |column| column_display?(column) }
    return columns
  end

  def displaying_attribute_columns
    return PLAYER_ATTRIBUTE_COLUMNS.select { |column| instance_variable_get("@#{column.name}") == YES }
  end

  RECOMMENDED_COLUMN_NAMES = [
    :position_id, :skill_move, :is_right_dominant, :both_feet_level, :height, :birth_year, :overall
  ]

  def set_recommended_columns
    PLAYER_PROPERTY_NAMES.each do |name|
      instance_variable_set("@#{name}", RECOMMENDED_COLUMN_NAMES.include?(name) ? YES : NO)
    end
  end
  #TODO: Split into two methods, all and no
  def set_all_or_no_columns(is_all=true)
    value = is_all ? YES : NO
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
  GENERAL_GOALKEEPING_ATTRIBUTE_NAMES = [:acceleration, :positiveness, :balance, :jump, :positioning, :reaction, :stamina,
                                         :physical, :tactics, :vision]

  GENERAL_ATTRIBUTE_NAMES = GENERAL_ATTRIBUTE_NAMES_1 + GENERAL_ATTRIBUTE_NAMES_2
  OFFENSIVE_ATTRIBUTE_NAMES = OFFENSIVE_ATTRIBUTE_NAMES_1 + OFFENSIVE_ATTRIBUTE_NAMES_2

  FIELD_ATTRIBUTE_NAMES = GENERAL_ATTRIBUTE_NAMES + OFFENSIVE_ATTRIBUTE_NAMES + DEFENSIVE_ATTRIBUTE_NAMES

  def set_general_attributes
    set_specified_attributes(GENERAL_ATTRIBUTE_NAMES)
  end
  def set_offensive_attributes
    set_specified_attributes(OFFENSIVE_ATTRIBUTE_NAMES)
  end
  def set_defensive_attributes
    set_specified_attributes(DEFENSIVE_ATTRIBUTE_NAMES)
  end
  def set_goalkeeping_attributes
    set_specified_attributes(GENERAL_GOALKEEPING_ATTRIBUTE_NAMES + GOALKEEPING_ATTRIBUTE_NAMES)
  end

  def set_specified_attributes(attribute_names)
    attribute_names = attribute_names.map { |name| name.kind_of?(Symbol) ? name : name.intern }
    PLAYER_ATTRIBUTE_NAMES.each do |name|
      instance_variable_set("@#{name}", YES) if attribute_names.include?(name)
    end
  end

  #TODO: Split into two methods, all and no
  def set_all_or_no_attributes(is_all=true)
    value = is_all ? YES : NO
    PLAYER_ATTRIBUTE_NAMES.each do |name|
      instance_variable_set("@#{name}", value)
    end
    @no_attributes = true
  end

  private

    def column_display?(column)
      return true unless INSTANCE_VARIABLE_NAMES.include?(column.name.intern)
      return instance_variable_get("@#{column.name}") == YES
    end
end


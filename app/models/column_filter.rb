class ColumnFilter

  YES = '1'
  NO  = '0'

  INSTANCE_VARIABLE_DEFAULT_VALUE = YES

  def initialize(hash=nil)
    ColumnFilter.instance_variable_names.each do |name|
      value = hash.nil? ? INSTANCE_VARIABLE_DEFAULT_VALUE : hash[name]
      instance_variable_set("@#{name}", value)
    end
  end

  def self.instance_variable_names
    unless defined?(@@instance_variable_names)
      ColumnFilter.initialize_attr_accessors
    end

    return @@instance_variable_names
  end

  PLAYER_PROPERTY_NAMES_NOT_TO_FILTER = [:id, :name, :order_number, :note]

  def self.initialize_attr_accessors
    @@player_attribute_columns = PlayerAttribute.content_columns
    @@player_attribute_names = @@player_attribute_columns.map { |column| column.name.intern }

    @@instance_variable_names = ColumnFilter.player_property_names + @@player_attribute_names

    attr_accessor *@@instance_variable_names
  end

  def self.player_property_names
    unless defined?(@@player_property_names)
      @@player_property_names = Player.columns.map { |column| column.name.intern } \
            .select { |name| ! PLAYER_PROPERTY_NAMES_NOT_TO_FILTER.include?(name) }
    end
    return @@player_property_names
  end

  COLUMN_NAMES_NOT_TO_DISPLAY = %w(id order_number note)

  def self.displaying_columns
    return Player.columns.select { |column| ! COLUMN_NAMES_NOT_TO_DISPLAY.include?(column.name) }
  end

  def displaying_columns
    return ColumnFilter.displaying_columns.select { |column| column_display?(column) }
  end

  def displaying_attribute_columns
    return @@player_attribute_columns.select { |column| instance_variable_get("@#{column.name}") == YES }
  end

  RECOMMENDED_COLUMN_NAMES = [
    :position_id, :skill_move, :is_right_dominant, :both_feet_level, :height, :birth_year, :overall
  ]

  def set_recommended_columns
    @@player_property_names.each do |name|
      instance_variable_set("@#{name}", RECOMMENDED_COLUMN_NAMES.include?(name) ? YES : NO)
    end
  end
  def set_all_or_no_columns(all=true)
    value = all ? YES : NO
    @@player_property_names.each do |name|
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
    @@player_attribute_names.each do |name|
      instance_variable_set("@#{name}", YES) if attribute_names.include?(name)
    end
  end

  def set_all_or_no_attributes(all=true)
    value = all ? YES : NO
    @@player_attribute_names.each do |name|
      instance_variable_set("@#{name}", value)
    end
  end

  private

    def column_display?(column)
      return true unless ColumnFilter.instance_variable_names.include?(column.name.intern)
      return instance_variable_get("@#{column.name}") == YES
    end
end


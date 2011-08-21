module PlayersHelper

  def column_index(column_name)
    return column_attribute(column_name, 0)
  end

  DEFAULT_ALIGN = 'left'
  HASH_ALIGN = {:L => 'left', :R => 'right', :C => 'center'}

  def column_align(column_name)
    align = column_attribute(column_name, 1)
    return HASH_ALIGN[align] || DEFAULT_ALIGN
  end

  def column_attribute(column_name, index)
    attributes = COLUMN_ATTRIBUTES[column_name.intern]
    return nil unless attributes
    return attributes[index]
  end

  COLUMN_ATTRIBUTES = {
    :id                => ['id'        , :R],
    :name              => ['Name'      , :L],
    :first_name        => ['First Name', :L],
    :number            => ['No'        , :C],
    :position_id       => ['Positions' , :L],
    :skill_move        => ['Skill'     , :L],
    :is_right_dominant => ['Ft'        , :C],
    :both_feet_level   => ['Weak Ft'   , :L],
    :height            => ['H'         , :R],
    :weight            => ['W'         , :R],
    :birth_year        => ['Ag'        , :R],
    :nation_id         => ['Nation'    , :L],
    :overall           => ['Ov'        , :R],
    :market_value      => ['MV'        , :R],
    :wage              => ['Wage'      , :R],
    :age_add_inj       => ['AgInj'     , :R],
    :note              => ['Note'      , :L],
  }.freeze

  def displaying_player_attribute_names
    # [nil] to instruct to output <br />
    return \
        ColumnFilter::GENERAL_ATTRIBUTE_NAMES_1   + ColumnFilter::GENERAL_ATTRIBUTE_NAMES_2   + [nil] \
      + ColumnFilter::OFFENSIVE_ATTRIBUTE_NAMES_1 + [nil] \
      + ColumnFilter::OFFENSIVE_ATTRIBUTE_NAMES_2 + [nil] \
      + ColumnFilter::DEFENSIVE_ATTRIBUTE_NAMES   + ColumnFilter::GOALKEEPING_ATTRIBUTE_NAMES
  end

  def prepare_superior_attribute_values
    values = Hash.new { |h, k| h[k] = 0 }
    if @players.size >= 2
      attrs = @players.map { |player| player.player_attribute }
      @attribute_columns.map(&:name).each do |attr_name|
        values[attr_name] = attrs.map { |attr| attr.read_attribute(attr_name) }.max
      end
    end

    return values
  end

  def html_class_for_attribute_display(attr_name, value, is_leftmost)
    clazz = ''
    clazz =  'leftmost_of_attributes' if is_leftmost
    clazz += ' sorted_field'    if @sorted_field_names.include?(attr_name)
    top_five = @attribute_top_five_values[attr_name]
    clazz += ' top_five_values' if ! top_five.nil? && value >= top_five
    superior_value = @superior_attribute_values[attr_name]
    clazz += ' superior_attribute_value' if superior_value > 0 and value >= superior_value
    return clazz
  end
end


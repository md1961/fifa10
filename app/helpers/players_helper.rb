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
    if @players.size == 2
      attrs1 = @players[0].player_attribute
      attrs2 = @players[1].player_attribute
      @attribute_columns.map(&:name).each do |attr_name|
        value1 = attrs1.read_attribute(attr_name)
        value2 = attrs2.read_attribute(attr_name)
        values[attr_name] = value1 > value2 ? value1 : value2
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

  def options_for_attrs_and_props(attrs_and_props)
    return attrs_and_props.map { |x| [column_name2display(x).titleize, x.to_s] }
  end

  COMMAND_SAMPLES = [
    ["9 with 2"  , "Exchange #9 with #2"],
    ["21 to 13"  , "Insert #21 before #13"],
    ["loan 15 "  , "Loan/Back from loan #15"],
    ["injure 10" , "Put #10 into injury list"],
    ["recover 7" , "Recover #7 from injury/disabled"],
    ["off"       , "Rest/Put back #11"],
    ["hot 5"     , "Hot/Cool #5"],
    ["notwell 4" , "Not well/Put back #4"],
    ["disable 3" , "Disable/Enable #3"],
    ["until 2 30", "Set date disabled until of #2 at 30 days from next match"],
    ["show 1 ...", "Show (and compare) player's attributes"],
    ["z"         , "Undo last command"],
  ]

  def command_samples_for_roster_chart
    samples = COMMAND_SAMPLES
    num_left = (samples.size / 2.0).ceil
    num_right = samples.size - num_left
    rows = Array.new
    samples.first(num_left).zip(samples.last(num_right)) do |left, right|
      cells = [left, right].map { |values|
        next unless values
        "<td>#{values.first}</td><td>:</td><td>#{values.last}</td>"
      }.join("<td>#{'&nbsp' * 8}</td>")
      rows << "<tr>#{cells}</tr>"
    end
    return content_tag(:table, rows.join("\n").html_safe)
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
end

module PlayersHelper

  NO_MATCH_DISPLAY = "(none)"

  def next_matches_display(next_matches)
    next1, next2, next3 = next_matches
    format = "(%s day rest)"
    rest1 = next1 && next2 ? format % (next2.date_match - next1.date_match - 1) : ""
    rest2 = next2 && next3 ? format % (next3.date_match - next2.date_match - 1) : ""
    return <<-END
      <table>
        <tr>
          <td><span style="font-size: large">Next Match:</span></td>
          <td colspan="2"><span style="font-size: x-large">
            #{next1 || NO_MATCH_DISPLAY}
          </span></td>
        </tr>
        <tr>
          <td>Followed by:</td>
          <td>#{rest1}</td>
          <td>#{next2 || NO_MATCH_DISPLAY}</td>
        </tr>
        <tr>
          <td />
          <td>#{rest2}</td>
          <td>#{next3 || NO_MATCH_DISPLAY}</td>
        </tr>
      </table>
    END
  end

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

  def column_name2meaningful(column_name)
    return \
      case column_name.to_s
      when 'position_id'
        'position'
      when 'is_right_dominant'
        'foot'
      when 'skill_move'
        'skill_moves'
      when 'both_feet_level'
        'week_foot'
      when 'birth_year'
        'age'
      when 'nation_id'
        'nation'
      else
        column_name.to_s
      end
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
    return attrs_and_props.map { |x| [column_name2meaningful(x).titleize, x.to_s] }
  end

  def command_samples_for_roster_chart
    return [
      "s9 with b2 : Exchange 'Starter 9' with 'Bench 2'",
      "r21 to r13 : Insert 'Reserve 21' before 'Reserve 13'",
      "loan r15   : Loan/Back from loan 'Reserve 15'",
      "recover s7 : Recover 'Starter 7' from injury list",
    ].join('<br />')
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
    :note              => ['Note'      , :L],
  }.freeze
end

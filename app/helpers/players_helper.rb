module PlayersHelper

  def column_index(column)
    return column_attribute(column, 0)
  end

  DEFAULT_ALIGN = 'left'
  HASH_ALIGN = {:L => 'left', :R => 'right', :C => 'center'}

  def column_align(column)
    align = column_attribute(column, 1)
    return HASH_ALIGN[align] || DEFAULT_ALIGN
  end

  def column_attribute(column, index)
    attributes = COLUMN_ATTRIBUTES[column.name.intern]
    return nil unless attributes
    return attributes[index]
  end

  def column_name2meaningful(column_name)
    return \
      case column_name.to_s
      when 'position_id'
        'position'
      when 'is_right_dominant'
        'dominant_feet'
      when 'both_feet_level'
        'week_feet'
      when 'nation_id'
        'nationality'
      else
        column_name.to_s
      end
  end

  def column_name2display(column_name)
    s = column_name.to_s.titleize
    #s.gsub!(/([a-z])([A-Z])/, '\1 \2')
    s.sub!(/([FGP])k/, '\1K')
    return s
  end

  def displaying_player_attribute_names
    # [nil] to instruct to output <br />
    return \
        ColumnFilter::GENERAL_ATTRIBUTE_NAMES_1   + [nil] \
      + ColumnFilter::GENERAL_ATTRIBUTE_NAMES_2   + [nil] \
      + ColumnFilter::OFFENSIVE_ATTRIBUTE_NAMES_1 + [nil] \
      + ColumnFilter::OFFENSIVE_ATTRIBUTE_NAMES_2 + [nil] \
      + ColumnFilter::DEFENSIVE_ATTRIBUTE_NAMES   + [nil] \
      + ColumnFilter::GOALKEEPING_ATTRIBUTE_NAMES
  end

  def command_samples_for_roster_chart
    return [
      "s9 with b2 : Exchange 'Starter 9' with 'Bench 2'",
      "r21 to r13 : Insert 'Reserve 21' before 'Reserve 13'",
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
    :team_id           => ['Team'      , :L],
    :overall           => ['Ov'        , :R],
    :market_value      => ['MV'        , :R],
  }.freeze
end

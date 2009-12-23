module PlayersHelper

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
    :birth_year        => ['Birth'     , :R],
    :nation_id         => ['Nation'    , :L],
    :team_id           => ['Team'      , :L],
  }.freeze

  def column_index(column)
    return column_attribute(column, 0)
  end

  DEFAULT_ALIGN = 'left'

  def column_align(column)
    align = column_attribute(column, 1)
    return DEFAULT_ALIGN unless align
    return align == :L ? 'left' : align == :R ? 'right' : 'center'
  end

  def column_attribute(column, index)
    attributes = COLUMN_ATTRIBUTES[column.name.intern]
    return nil unless attributes
    return attributes[index]
  end

  def player_attribute_abbrs
    return PlayerAttribute.abbrs
  end

  def column_name2display(column_name)
    s = column_name.camelize
    s.sub!(/([a-z])([A-Z])/, '\1 \2')
    s.sub!(/([FGP])k/, '\1K')
    return s
  end
end

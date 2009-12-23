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

  def column_name2display(column_name)
    s = column_name.to_s.camelize
    s.sub!(/([a-z])([A-Z])/, '\1 \2')
    s.sub!(/([FGP])k/, '\1K')
    return s
  end

  def displaying_player_attribute_names
    return [:acceleration, :positiveness, :quickness, :balance, :jump, :positioning, nil,
            :reaction, :speed, :stamina, :physical, :tactics, :vision, nil,
            :control, :cross, :curve, :dribble, :goalmaking, :fk_accuracy, :head_accuracy, nil,
            :long_pass, :long_shot, :pk, :short_pass, :shot_power, :volley, nil,
            :mark, :sliding, :tackle, nil,
            :gk_dive, :gk_handling, :gk_kick, :gk_positioning, :gk_reaction]
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
    :birth_year        => ['Birth'     , :R],
    :nation_id         => ['Nation'    , :L],
    :team_id           => ['Team'      , :L],
  }.freeze
end

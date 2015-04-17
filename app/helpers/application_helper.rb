module ApplicationHelper

  def nbsp(length=1)
    return ('&nbsp;' * length).html_safe
  end

  def bold(str)
    return content_tag(:b, str)
  end

  MAP_COLUMN_NAME_ADJUSTED = {
    :position_id       => :position,
    :is_right_dominant => :foot,
    :skill_move        => :skill_moves,
    :both_feet_level   => :week_foot,
    :birth_year        => :age,
    :nation_id         => :nation,
    :quickness         => :agility,
    :jump              => :jumping,
    :reaction          => :reactions,
    :speed             => :sprint_speed,
    :physical          => :strength,
    :positiveness      => :aggression,
    :tactics           => :tactic_aware,
    :control           => :ball_control,
    :cross             => :crossing,
    :dribble           => :dribbling,
    :goalmaking        => :finishing,
    :long_shot         => :long_shots,
    :mark              => :marking,
    :pk                => :penalties,
    :sliding           => :slide_tackle,
    :tackle            => :stand_tackle,
    :volley            => :volleys,
    :gk_dive           => :gk_diving,
    :gk_kick           => :gk_kicking,
    :gk_reaction       => :gk_reflexes,
  }

  def column_name2display(column_name)
    column_name = column_name.intern if column_name.respond_to?(:intern)
    return 'ID' if column_name == :id

    column_name = MAP_COLUMN_NAME_ADJUSTED[column_name] || column_name
    s = column_name.to_s.titleize
    s.sub!(/([FGP])k/, '\1K')
    return s
  end
end


# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def nbsp(length=1)
    return '&nbsp;' * length
  end

  MAP_COLUMN_NAME_ADJUSTED = {
    :quickness    => :agility,
    :jump         => :jumping,
    :reaction     => :reactions,
    :speed        => :sprint_speed,
    :physical     => :strength,
    :positiveness => :aggression,
    :tactics      => :tactic_aware,
    :control      => :ball_control,
    :cross        => :crossing,
    :dribble      => :dribbling,
    :goalmaking   => :finishing,
    :long_shot    => :long_shots,
    :mark         => :marking,
    :pk           => :penalties,
    :sliding      => :slide_tackle,
    :tackle       => :stand_tackle,
    :volley       => :volleys,
    :gk_dive      => :gk_diving,
    :gk_kick      => :gk_kicking,
    :gk_reaction  => :gk_reflexes,
  }

  def column_name2display(column_name)
    return 'ID' if column_name == 'id'

    column_name = MAP_COLUMN_NAME_ADJUSTED[column_name.intern] || column_name
    s = column_name.to_s.titleize
    s.sub!(/([FGP])k/, '\1K')
    return s
  end
end


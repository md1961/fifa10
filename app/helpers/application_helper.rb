# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def nbsp(length=1)
    return '&nbsp;' * length
  end

  def column_name2display(column_name)
    return 'ID' if column_name == 'id'

    s = column_name.to_s.titleize
    s.sub!(/([FGP])k/, '\1K')
    return s
  end
end

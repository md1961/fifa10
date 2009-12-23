# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def nbsp(length=1)
    return '&nbsp;' * length
  end
end

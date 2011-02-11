module TeamsHelper

  def column_align(column_name)
    return 'right' if %(id, year_founded).include?(column_name)
    return 'left'
  end
end


module TeamsHelper

  def column_align_team(column_name)
    return 'right' if %(id, year_founded).include?(column_name)
    return 'left'
  end
end


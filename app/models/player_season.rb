class PlayerSeason < ActiveRecord::Base
  belongs_to :player
  belongs_to :season

  ATTRIBUTES_NOT_TO_SUCCEED = %w(id season_id).freeze

  def attributes_to_succeed
    return attributes.reject { |name, dump| ATTRIBUTES_NOT_TO_SUCCEED.include?(name) }
  end

  def disabled?
    return is_disabled
  end

  def disable
    self.is_disabled = true
  end
end

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

  def recovered?(date_as_of)
    return disabled? && disabled_until < date_as_of
  end

  def disable(toggles=false)
    unless toggles
      self.is_disabled = true
    else
      self.is_disabled = ! is_disabled
    end
  end
end

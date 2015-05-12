class Nation < ActiveRecord::Base
  belongs_to :region
  has_many :players
  has_many :teams

  def manutd?
    return false
  end

  def to_s
    return name
  end
end

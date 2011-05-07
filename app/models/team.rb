class Team < ActiveRecord::Base
  has_many :seasons
  has_many :players
  belongs_to :nation

  validates :name, :presence => true, :uniqueness => true
  validates :year_founded, :numericality => true, :inclusion => 1800..2000, :allow_nil => true

  def get(name)
    return nation.name if name == 'nation_id'
    return read_attribute(name)
  end

  def manutd?
    return name == "Manchester United"
  end

  def abbr_name
    return abbr || name
  end

  def to_s
    return name
  end

  COLUMN_NAMES_TO_LIST = %()
end

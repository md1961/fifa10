class Team < ActiveRecord::Base
  has_many :seasons
  has_many :players
  belongs_to :nation

  validates_presence_of   :name
  validates_uniqueness_of :name
  validates_numericality_of :year_founded, :greater_than => 1800, :less_than => 2000, :allow_nil => true

  def get(name)
    return nation.name if name == 'nation_id'
    return read_attribute(name)
  end

  def to_s
    return name
  end

  COLUMN_NAMES_TO_LIST = %()
end

class Team < ActiveRecord::Base
  has_many :seasons
  has_many :players
  belongs_to :nation

  def get(name)
    return nation.name if name == 'nation_id'
    return read_attribute(name)
  end

  COLUMN_NAMES_TO_LIST = %()
end

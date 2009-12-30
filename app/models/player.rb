class Player < ActiveRecord::Base
  belongs_to :nation
  belongs_to :team
  belongs_to :position
  has_many :player_positions
  has_many :sub_positions, :through => :player_positions, :source => :position
  has_one :player_attribute

  ORDER_WHEN_LIST = "order_number"

  def self.list(team_id)
    return find_all_by_team_id(team_id, :order => ORDER_WHEN_LIST)
  end

  def positions
    return [position] + sub_positions
  end

  def last_name_first_name
    names = Array.new
    names << name.sub(/\A[A-Z]\. /, "")
    names << first_name unless first_name.blank?
    return names.join(', ')
  end

  def age(current_year=nil)
    current_year = team.current_year
    return current_year - birth_year
  end

  def get(name)
    name = name.to_s
    return 0 if name == 'none'
    value = self.send(:attributes)[name]
    value = self.player_attribute.send(:attributes)[name] unless value
    value = self.send(name) unless value
    return value
  end
end

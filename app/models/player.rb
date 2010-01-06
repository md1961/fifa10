class Player < ActiveRecord::Base
  belongs_to :nation
  belongs_to :team
  belongs_to :position
  has_many :player_positions
  has_many :sub_positions, :through => :player_positions, :source => :position
  has_one :player_attribute

  validates_presence_of :name, :number, :position_id, :skill_move, :both_feet_level, \
                        :height, :weight, :birth_year, :nation_id, :team_id, :overall
  validates_inclusion_of :is_right_dominant, :in => [true, false]
  validates_uniqueness_of :name, :number
  validates_numericality_of :number,          :only_integer => true, :greater_than =>    0
  validates_numericality_of :skill_move,      :only_integer => true, :greater_than =>    0, :less_than_or_equal_to => 5
  validates_numericality_of :both_feet_level, :only_integer => true, :greater_than =>    0, :less_than_or_equal_to => 5
  validates_numericality_of :height,          :only_integer => true, :greater_than =>  150, :less_than => 220
  validates_numericality_of :weight,          :only_integer => true, :greater_than =>   50, :less_than => 100
  validates_numericality_of :birth_year,      :only_integer => true, :greater_than => 1950
  validates_numericality_of :overall,         :only_integer => true, :greater_than =>   40, :less_than => 100
  validates_numericality_of :market_value,    :only_integer => true

  TEST_DATA_FOR_NEW = {
    :name              => 'Kumagai',
    :first_name        => 'Yuya',
    :number            => 55,
    :position_id       => 10,
    :skill_move        => 2,
    :is_right_dominant => true,
    :both_feet_level   => 1,
    :height            => 151,
    :weight            => 51,
    :birth_year        => 1997,
    :nation_id         => 1,
    :overall           => 49,
    :market_value      => 1430,
  }

  ORDER_WHEN_LIST = "order_number"

  def self.list(team_id)
    return find_all_by_team_id(team_id, :order => ORDER_WHEN_LIST)
  end

  def self.next_order_number(team_id)
    return 1 + maximum(:order_number, :conditions => ["team_id = ?", team_id])
  end

  def self.player_attribute_top_values(order, players)
    map_values = Hash.new
    PlayerAttribute.content_columns.map(&:name).each do |name|
      values = players.map(&:player_attribute).map do |attribute|
        attribute.send(:attributes)[name]
      end
      map_values[name] = values.sort.reverse[order - 1]
    end

    return map_values
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

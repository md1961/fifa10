class Player < ActiveRecord::Base
  belongs_to :nation
  has_many :player_seasons
  has_many :seasons, :through => :player_seasons
  belongs_to :position
  has_many :player_positions
  has_many :sub_positions, :through => :player_positions, :source => :position
  has_one :player_attribute

  MAX_HEIGHT_IN_CM = 220
  MAX_WEIGHT_IN_KG = 100

  validates_presence_of :name, :number, :position_id, :skill_move, :both_feet_level, \
                        :height, :weight, :birth_year, :nation_id, :overall
  validates_inclusion_of :is_right_dominant, :in => [true, false]
  # TODO: uniqueness of :name and :number?
  #validates_uniqueness_of :name  , :scope => [:season]
  #validates_uniqueness_of :number, :scope => [:season]
  validates_numericality_of :number,          :only_integer => true, :greater_than =>    0
  validates_numericality_of :skill_move,      :only_integer => true, :greater_than =>    0, :less_than_or_equal_to => 5
  validates_numericality_of :both_feet_level, :only_integer => true, :greater_than =>    0, :less_than_or_equal_to => 5
  validates_numericality_of :height,          :only_integer => true, :greater_than =>  150, :less_than => MAX_HEIGHT_IN_CM
  validates_numericality_of :weight,          :only_integer => true, :greater_than =>   50, :less_than => MAX_WEIGHT_IN_KG
  # TODO: validates with :birth_year, :overall and :market_value?
  #validates_numericality_of :birth_year,      :only_integer => true, :greater_than => 1950
  #validates_numericality_of :overall,         :only_integer => true, :greater_than =>   40, :less_than => 100
  #validates_numericality_of :market_value,    :only_integer => true

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

  #TODO: Quit using @@current_year and correct age()
  @@current_year = Constant.get(:default_current_year)

  def self.list(season_id, includes_on_loan=true, for_lineup=false)
    season = Season.find(season_id)
    @@current_year = season.year_start

    players = season.players
    players = players.select { |player| ! player.on_loan?(season_id) } unless includes_on_loan

    season_id = 0 if for_lineup
    players.sort! { |p1, p2| p1.order_number(season_id).<=>(p2.order_number(season_id)) }

    return players
  end

  def self.next_order_number(season_id)
    players = list(season_id)
    order_numbers = players.map { |p| p.order_number(season_id) }
    return (order_numbers.empty? ? 0 : order_numbers.max) + 1
  end

  def self.player_attribute_top_values(order, season_id)
    players = list(season_id)
    map_values = Hash.new
    PlayerAttribute.content_columns.map(&:name).each do |name|
      values = players.map(&:player_attribute).map do |attribute|
        attribute.send(:attributes)[name]
      end
      top_values = values.sort.reverse[0, order] - [0, nil]
      map_values[name] = top_values.reverse[0]
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
    return (current_year || @@current_year) - birth_year
  end

  def order_number(season_id)
    if season_id == 0
      return SimpleDB.instance.get(:map_lineup)[id]
    end

    player_season = player_seasons.find_by_season_id(season_id)
    return player_season ? player_season.order_number : nil
  end

  def on_loan?(season_id)
    player_season = player_seasons.find_by_season_id(season_id)
    return player_season ? player_season.on_loan : false
  end

  def set_on_loan(on_loan, season_id)
    player_season = player_seasons.find_by_season_id(season_id)
    player_season.on_loan = on_loan
    player_season.save!
  end

  def set_order_number(number, season_id)
    if season_id == 0
      map_lineup = SimpleDB.instance.get(:map_lineup)
      map_lineup[id] = number
      SimpleDB.instance.set(:map_lineup, map_lineup)
    end

    player_season = player_seasons.find_by_season_id(season_id)
    if player_season
      player_season.order_number = number
      player_season.save
    else
      player_seasons << PlayerSeason.new(:player_id => id, :season_id => season_id, :order_number => number)
    end
  end

  def set_next_order_number(season_id)
    player_seasons << PlayerSeason.new(:season_id => season_id,
                                       :order_number => Player.next_order_number(season_id))
  end

  def remove_from_rosters(season_id)
    player_season = player_seasons.find_by_season_id(season_id)
    player_season.destroy
  end

  def get(name)
    name = name.to_s
    return 0 if name == 'none'
    value = self.send(:attributes)[name]
    value = self.player_attribute.send(:attributes)[name] unless value
    value = self.send(name) unless value
    return value
  end

  protected

    MINIMUM_FEET_INCH_TO_CONVERT = 500

    def before_validation
      if height > MINIMUM_FEET_INCH_TO_CONVERT
        feet = (height / 100).to_i
        inch = height - feet * 100
        if inch < 12
          self.height = UnitConverter.feet_inch2cm(feet, inch).round
        end
      end

      self.weight = UnitConverter.lb2kg(weight).round if weight > MAX_WEIGHT_IN_KG
    end
end


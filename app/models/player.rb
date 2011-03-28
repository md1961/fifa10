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

  SAMPLE_DATA = {
    :name => 'Yuya',
    :number => '99',
    :position_id => 3,
    :skill_move => 3,
    :is_right_dominant => true,
    :both_feet_level => 3,
    :height => 170,
    :weight => 51,
    :birth_year => 13,
    :nation_id => 7,
    :overall => 99,
  }

  #TODO: :uniqueness below won't work for season(s)
  # Should create a Player for each season
  validates :name, :presence => true #, :uniqueness => {:scope => :season}

  validates_presence_of :position_id, :skill_move, :both_feet_level, :height, :weight, :birth_year, :nation_id, :overall
  validates_inclusion_of :is_right_dominant, :in => [true, false]
  validates_numericality_of :number,          :only_integer => true, :greater_than =>    0, :allows_nil => true
  validates_numericality_of :skill_move,      :only_integer => true, :greater_than =>    0, :less_than_or_equal_to => 5
  validates_numericality_of :both_feet_level, :only_integer => true, :greater_than =>    0, :less_than_or_equal_to => 5
  validates_numericality_of :height,          :only_integer => true, :greater_than =>  150, :less_than => MAX_HEIGHT_IN_CM
  validates_numericality_of :weight,          :only_integer => true, :greater_than =>   50, :less_than => MAX_WEIGHT_IN_KG
  # TODO: validates with :birth_year, :overall and :market_value?
  #validates_numericality_of :birth_year,      :only_integer => true, :greater_than => 1950
  #validates_numericality_of :overall,         :only_integer => true, :greater_than =>   40, :less_than => 100
  #validates_numericality_of :market_value,    :only_integer => true

  NIL_PLAYER = begin; p = Player.new; p.id = 0; p.freeze; end

  #TODO: Quit using @@current_year and correct age()
  @@current_year = Constant.get(:default_current_year)

  def self.list(season_id, includes_on_loan=true, for_lineup=false)
    season = Season.find(season_id)
    @@current_year = season.year_start

    players = season.players
    players = players.select { |player| ! player.on_loan?(season_id) } unless includes_on_loan

    season_id = 0 if for_lineup
    players = players.sort_by { |player| player.order_number(season_id) }

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

  def gk?
    return position.gk?
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
      return
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

  def hot?(season_id)
    player_season = player_seasons.find_by_season_id(season_id)
    return player_season ? player_season.is_hot : false
  end

  def set_hot(is_hot, season_id)
    player_season = player_seasons.find_by_season_id(season_id)
    player_season.is_hot = is_hot
    player_season.is_not_well = false
    player_season.save!
  end

  def not_well?(season_id)
    player_season = player_seasons.find_by_season_id(season_id)
    return player_season ? player_season.is_not_well : false
  end

  def set_not_well(is_not_well, season_id)
    player_season = player_seasons.find_by_season_id(season_id)
    player_season.is_not_well = is_not_well
    player_season.is_hot = false
    player_season.save!
  end

  def remove_from_rosters(season_id)
    player_season = player_seasons.find_by_season_id(season_id)
    player_season.destroy
  end

  def inactive?(season_id)
    return on_loan?(season_id) || disabled?(season_id)
  end

  #TODO: Extract to module Disableable???

  def to_be_disabled?(season_id)
    return rand(100) < pct_to_be_disabled(season_id)
  end

  def disabled?(season_id)
    player_season = player_seasons.find_by_season_id(season_id)
    return player_season.disabled?
  end

  def back_for_next?(season_id)
    return false unless disabled?(season_id)
    date_until = disabled_until(season_id)
    next_next_match = Match.nexts(season_id, 2)[-1]
    return date_until < next_next_match.date_match
  end

  def disabled_until(season_id)
    player_season = player_seasons.find_by_season_id(season_id)
    return player_season.disabled_until
  end

  def set_disabled_until(date_until, season_id)
    player_season = player_seasons.find_by_season_id(season_id)
    player_season.disabled_until = date_until
    player_season.save!
  end

  def disable(season_id, toggles=false)
    player_season = player_seasons.find_by_season_id(season_id)
    player_season.disable(toggles)
    if player_season.disabled?
      today = Match.nexts(season_id).first.date_match
      player_season.disabled_until = today + disabled_days(season_id) - 1
    end
    player_season.save!
  end

    #TODO: to be moved to Constant

    MIN_AGE = 17.0
    MAX_AGE = 45.0

    AGE_INCREMENT_WHEN_NOT_WELL = 7

    INCREMENTS_OF_PCT_TO_BE_DISABLED = [
      [MIN_AGE,  0.0],
      [MAX_AGE, 10.0],
    ].freeze

    MIN_DISABLED_TERM =  3
    MAX_DISABLED_TERM = 30
    INCREMENTS_OF_MAX_DISABLED_TERM = [
      [MIN_AGE, -10.0],
      [MAX_AGE,  10.0],
    ].freeze

    PCT_DISABLED_UNTIL_CHANGE = 25
    MIN_DISABLED_UNTIL_CHANGE = -5.0
    MAX_DISABLED_UNTIL_CHANGE =  5.0
    INCREMENTS_OF_DISABLED_UNTIL = [
      [MIN_AGE, -5.0],
      [MAX_AGE,  5.0],
    ].freeze

    PCT_HOT_OR_NOT_WELL_EXPIRE = 5

    def age_for_disablement(season_id)
      return age + (age_add_inj || 0) + (not_well?(season_id) ? AGE_INCREMENT_WHEN_NOT_WELL : 0)
    end
    private :age_for_disablement

    def pct_to_be_disabled(season_id)
      age0, inc0, age1, inc1 = INCREMENTS_OF_PCT_TO_BE_DISABLED.flatten
      increment = (inc0 + (inc1 - inc0) / (age1 - age0) * (age_for_disablement(season_id) - age0)).to_i
      increment -= Constant.get(:gk_pct_dec_to_be_disabled) if gk?
      return Constant.get(:base_pct_to_be_disabled) + increment
    end
    private :pct_to_be_disabled

    def disabled_days(season_id, can_be_extended=true)
      age0, inc0, age1, inc1 = INCREMENTS_OF_MAX_DISABLED_TERM.flatten
      increment_max = (inc0 + (inc1 - inc0) / (age1 - age0) * (age_for_disablement(season_id) - age0)).to_i

      min = MIN_DISABLED_TERM
      max = MAX_DISABLED_TERM + increment_max
      days = (min + (max - min + 1) * rand).to_i

      if can_be_extended && rand(100) < pct_to_be_disabled_extendedly(season_id)
        days += disabled_days(season_id, false)
      end

      return days
    end
    private :disabled_days

    def pct_to_be_disabled_extendedly(season_id)
      return pct_to_be_disabled(season_id)
    end
    private :pct_to_be_disabled_extendedly

  def recover_from_disabled(date_as_of, season_id)
    player_season = player_seasons.find_by_season_id(season_id)
    if player_season.recovered?(date_as_of)
      self.disable(season_id, toggles=true)
      return true
    end
    return false
  end

  def examine_disabled_until_change(season_id)
    return nil unless disabled?(season_id)
    return nil unless rand(100) < PCT_DISABLED_UNTIL_CHANGE

    increment = increment_of_disable_until(season_id)
    return nil if increment == 0

    player_season = player_seasons.find_by_season_id(season_id)
    player_season.disabled_until += increment.days
    player_season.save!

    return increment
  end

    def increment_of_disable_until(season_id)
      age0, inc0, age1, inc1 = INCREMENTS_OF_DISABLED_UNTIL.flatten
      increment = (inc0 + (inc1 - inc0) / (age1 - age0) * (age_for_disablement(season_id) - age0)).to_i

      min = MIN_DISABLED_UNTIL_CHANGE
      max = MAX_DISABLED_UNTIL_CHANGE
      return (min + (max - min + 1) * rand).to_i + increment
    end
    private :increment_of_disable_until

  def examine_hot_or_not_well_expire(season_id)
    return false unless hot?(season_id) || not_well?(season_id)
    return false unless rand(100) < PCT_HOT_OR_NOT_WELL_EXPIRE

    if hot?(season_id)
      set_hot(false, season_id)
    else
      set_not_well(false, season_id)
    end

    return true
  end

  def self.player_available_with_max_overall(position, players, inactive_player_ids)
    active_players = players.reject { |player| inactive_player_ids.include?(player.id) }
    return pick_up_best_substitiute(position, active_players)
  end

    def self.pick_up_best_substitiute(position, players_from)
      players = players_from.sort_by { |player| player.overall }.reverse

      has_the_position   = Proc.new { |player| player.positions.include?(position) } 
      is_pos_in_same_cat = Proc.new { |player| player.position.in_same_category?(position) }

=begin
      [
        [has_the_position, is_pos_in_same_cat],
        [has_the_position],
        [is_pos_in_same_cat],
      ].each do |filters|
        selector = filters.pop
        filters.each do |filter|
          players = players.select &filter
        end
        player = players.find &selector
        return player if player
      end
      return nil
=end

      player = (players.select &has_the_position).find &is_pos_in_same_cat
      return player if player
      player = players.find &has_the_position
      return player if player
      player = players.find &is_pos_in_same_cat
      return player
    end
    private_class_method :pick_up_best_substitiute

  def get(name)
    name = name.to_s
    return 0 if name == 'none'
    value = self.send(:attributes)[name]
    value = self.player_attribute.send(:attributes)[name] unless value
    value = self.send(name) unless value
    return value
  end

  def nil_player?
    self == NIL_PLAYER
  end

  protected

    MINIMUM_FEET_INCH_TO_CONVERT = 500

    def before_validation
      if height && height > MINIMUM_FEET_INCH_TO_CONVERT
        feet = (height / 100).to_i
        inch = height - feet * 100
        if inch < 12
          self.height = UnitConverter.feet_inch2cm(feet, inch).round
        end
      end

      if weight && weight > MAX_WEIGHT_IN_KG
        self.weight = UnitConverter.lb2kg(weight).round
      end
    end
end


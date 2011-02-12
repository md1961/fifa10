class RowFilter
  cattr_accessor :players

  YES = '1'
  NO  = '0'

  MAX_PLAYERS = 50

  POSITION_CATEGORIES = Position.categories.map { |c| c.downcase.intern }

  def self.pos2name(position_name)
    return "pos_#{position_name.downcase}"
  end
  def self.name2pos(instance_variable_name)
    return instance_variable_name.to_s[4..-1].upcase
  end

  RAW_POSITIONS = Position.find(:all)
  POSITIONS = RAW_POSITIONS.map { |pos| pos2name(pos.name).intern }

  def self.id2name(id)
    return "p#{id}"
  end
  def self.name2id(instance_variable_name)
    return instance_variable_name.to_s[1..-1].to_i
  end
  
  PLAYER_IDS = (0 .. MAX_PLAYERS - 1).map { |id| id2name(id).intern }

  INSTANCE_VARIABLE_NAMES = POSITION_CATEGORIES + POSITIONS + PLAYER_IDS
  INSTANCE_VARIABLE_DEFAULT_VALUE = YES

  attr_accessor :option, *INSTANCE_VARIABLE_NAMES

  USE_POSITION_CATEGORIES = '1'
  USE_POSITIONS           = '2'
  USE_PLAYER_NAMES        = '3'

  DEFAULT_OPTION = USE_POSITION_CATEGORIES

  def initialize(hash=nil)
    INSTANCE_VARIABLE_NAMES.each do |name|
      value = hash.nil? ? INSTANCE_VARIABLE_DEFAULT_VALUE : hash[name]
      instance_variable_set("@#{name}", value)
    end
    @option = hash ? hash[:option] || DEFAULT_OPTION : DEFAULT_OPTION
  end

  def self.get_player(instance_variable_name)
    id = name2id(instance_variable_name)
    return @@players[id]
  end

  def self.player_instance_variable_names
    ids = (0 .. @@players.size - 1).to_a
    ids.sort! { |id1, id2|
      player1 = @@players[id1]
      player2 = @@players[id2]
      c1 = player1.position.category
      c2 = player2.position.category
      c_cmp = Position.compare_categories(c1, c2)
      c_cmp == 0 ? id1.<=>(id2) : c_cmp
    }
    return ids.map { |id| id2name(id) }
  end

  def use_position_categories?
    return @option == USE_POSITION_CATEGORIES
  end

  def use_positions?
    return @option == USE_POSITIONS
  end

  def use_player_names?
    return @option == USE_PLAYER_NAMES
  end

  def set_no_position_categories
    set_all_or_no_position_categories(false)
  end

  def set_all_or_no_position_categories(all=true)
    value = all ? YES : NO
    POSITION_CATEGORIES.each do |name|
      instance_variable_set("@#{name}", value)
    end

    @option = USE_POSITION_CATEGORIES
  end

  def set_no_positions
    POSITIONS.each do |name|
      instance_variable_set("@#{name}", NO)
    end

    @option = USE_POSITIONS
  end

  def self.position?(name)
    return RAW_POSITIONS.map(&:name).include?(name.upcase)
  end

  def set_position_by_name(position_name, bool_value=true)
    instance_variable_set("@#{RowFilter.pos2name(position_name)}", bool_value ? YES : NO)
  end

  def set_no_players
    PLAYER_IDS.each do |id|
      instance_variable_set("@#{id}", NO)
    end

    @option = USE_PLAYER_NAMES
  end

  def self.player_name_match(name)
    pattern = name.gsub(/\*/, '.*')
    pattern = pattern.gsub(/%/, '.*')
    pattern = /\A#{pattern}\z/i
    return @@players.select { |player| pattern =~ player.name.gsub(/ /, '') }
  end

  def set_player_by_name(name, bool_value=true)
    RowFilter.player_name_match(name).each do |player|
      id = @@players.index(player)
      instance_variable_set("@#{RowFilter.id2name(id)}", bool_value ? YES : NO)
    end
  end

  def displaying_players
    case @option
    when USE_POSITION_CATEGORIES
      categories = Position.categories.select do |category|
        instance_variable_get("@#{category.downcase}") == YES
      end
      selected_players = @@players.select do |player|
        categories.include?(player.position.category)
      end

      Position.find(:all).each do |position|
        name = RowFilter.pos2name(position.name)
        instance_variable_set("@#{name}", categories.include?(position.category) ? YES : NO)
      end

      set_player_instance_variables(selected_players)
    when USE_POSITIONS
      positions = Position.find(:all).select do |position| 
        instance_variable_get("@#{RowFilter.pos2name(position.name)}") == YES
      end

      selected_players = @@players.select do |player|
        player.positions.any? { |position| positions.include?(position) }
      end

      set_player_instance_variables(selected_players)
    when USE_PLAYER_NAMES
      selected_players = Array.new
      @@players.each_with_index do |player, index|
        name = RowFilter.id2name(index)
        selected_players << player if instance_variable_get("@#{name}") == YES
      end
    else
      raise "Impossible!! Check the code."
    end

    return selected_players
  end

  private

    def set_player_instance_variables(players)
      @@players.each_with_index do |player, index|
        name = RowFilter.id2name(index)
        instance_variable_set("@#{name}", players.include?(player) ? YES : NO)
      end
    end

  public

  class CannotFindPlayerException < Exception
  end
end


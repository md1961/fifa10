class RowFilter
  cattr_accessor :players

  MAX_PLAYERS = 50

  POSITION_CATEGORIES = Position.categories.map { |c| c.downcase.intern }

  def self.id2name(id)
    return "p#{id}"
  end
  def self.name2id(instance_variable_name)
    return instance_variable_name.to_s[1..-1].to_i
  end
  
  PLAYER_IDS = (0 .. MAX_PLAYERS - 1).map { |id| id2name(id).intern }

  INSTANCE_VARIABLE_NAMES = POSITION_CATEGORIES + PLAYER_IDS
  INSTANCE_VARIABLE_DEFAULT_VALUE = 1.to_s

  attr_accessor :option, *INSTANCE_VARIABLE_NAMES

  USE_POSITION_CATEGORIES = 1.to_s
  USE_POSITIONS           = 2.to_s
  USE_PLAYER_NAMES        = 3.to_s

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

  def self.instance_variable_names
    return INSTANCE_VARIABLE_NAMES
  end

  def self.position_categories
    return POSITION_CATEGORIES
  end

  def self.player_instance_variable_names
    ids = (0 .. @@players.size - 1).map
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

  def displaying_players
    case @option
    when USE_POSITION_CATEGORIES
      categories = Position.categories
      categories = categories.select { |category| category_display?(category) }
      selected_players = @@players.select do |player|
        categories.include?(player.position.category)
      end

      @@players.each_with_index do |player, index|
        name = RowFilter.id2name(index)
        instance_variable_set("@#{name}", selected_players.include?(player) ? '1' : '0')
      end
    when USE_POSITIONS
      selected_players = @@players
    when USE_PLAYER_NAMES
      selected_players = Array.new
      @@players.each_with_index do |player, index|
        name = RowFilter.id2name(index)
        selected_players << player if instance_variable_get("@#{name}") == '1'
      end
    else
      raise "Impossible!! Check the code."
    end
    return selected_players
  end

  private

    def category_display?(category)
      return instance_variable_get("@#{category.downcase}") == '1'
    end
end


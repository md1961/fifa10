module PlayersHelper

  COLUMN_ATTRIBUTES = {
    :id                => ['id'        , :R],
    :name              => ['Name'      , :L],
    :first_name        => ['First Name', :L],
    :number            => ['No'        , :C],
    :position_id       => ['Positions' , :L],
    :skill_move        => ['Skill'     , :L],
    :is_right_dominant => ['Ft'        , :C],
    :both_feet_level   => ['Both'      , :L],
    :height            => ['H'         , :R],
    :weight            => ['W'         , :R],
    :birth_year        => ['Birth'     , :R],
    :nation_id         => ['Nation'    , :L],
    :team_id           => ['Team'      , :L],
  }.freeze

  def column_index(column)
    return column_attribute(column, 0)
  end

  DEFAULT_ALIGN = 'left'

  def column_align(column)
    align = column_attribute(column, 1)
    return DEFAULT_ALIGN if align.nil?
    return align == :L ? 'left' : align == :R ? 'right' : 'center'
  end

  def column_attribute(column, index)
    attributes = COLUMN_ATTRIBUTES[column.name.intern]
    return nil if attributes.nil?
    return attributes[index]
  end

  def player_attribute_abbrs
    return PlayerAttribute.abbrs
  end

  def classRowFilter
    return RowFilter
  end

  def classColumnFilter
    return ColumnFilter
  end
  

  class RowFilter
    POSITION_CATEGORIES = Position.categories.map { |c| c.downcase.intern }

    INSTANCE_VARIABLE_NAMES = POSITION_CATEGORIES
    INSTANCE_VARIABLE_DEFAULT_VALUE = 1

    attr_accessor *INSTANCE_VARIABLE_NAMES

    def initialize(hash=nil)
      INSTANCE_VARIABLE_NAMES.each do |name|
        value = hash.nil? ? INSTANCE_VARIABLE_DEFAULT_VALUE : hash[name]
        instance_variable_set("@#{name}", value)
      end
    end

    def self.instance_variable_names
      return INSTANCE_VARIABLE_NAMES
    end

    def displaying_players(players)
      categories = Position.categories
      categories = categories.select { |category| category_display?(category) }
      players = players.select { |player| categories.include?(player.position.category) }
      return players
    end

    private

      def category_display?(category)
        return instance_variable_get("@#{category.downcase}") == '1'
      end

  end

  class ColumnFilter
    PLAYER_PROPERTY_NAMES = [
      :first_name, :number, :position, :skill_move, :is_right_dominant,
      :both_feet_level, :height, :weight, :birth_year, :nation_id
    ]

    INSTANCE_VARIABLE_NAMES = PLAYER_PROPERTY_NAMES
    INSTANCE_VARIABLE_DEFAULT_VALUE = 1

    attr_accessor *INSTANCE_VARIABLE_NAMES

    COLUMN_NAMES_NOT_TO_DISPLAY = %w(id team_id)

    def initialize(hash=nil)
      INSTANCE_VARIABLE_NAMES.each do |name|
        value = hash.nil? ? INSTANCE_VARIABLE_DEFAULT_VALUE : hash[name]
        instance_variable_set("@#{name}", value)
      end
    end

    def self.instance_variable_names
      return INSTANCE_VARIABLE_NAMES
    end

    def displaying_columns
      columns = Player.columns
      columns = columns.select { |column| ! COLUMN_NAMES_NOT_TO_DISPLAY.include?(column.name) }
      columns = columns.select { |column| column_display?(column) }
      return columns
    end

    private

      def column_display?(column)
        return true unless INSTANCE_VARIABLE_NAMES.include?(column.name.intern)
        return instance_variable_get("@#{column.name}") == '1'
      end
  end
end

class Position < ActiveRecord::Base

  def self.categories
    return find(:all, :select => 'DISTINCT category').map(&:category)
  end

  def self.compare_categories(c1, c2)
    index1 = categories.index(c1)
    index2 = categories.index(c2)
    index1 = -1 unless index1
    index2 = -1 unless index2
    return index1.<=>(index2)
  end

  CATEGORY_COLOR = {
    'Goalkeeper' => 'sandybrown',
    'Defender'   => 'yellow',
    'Midfielder' => 'lawngreen',
    'Forward'    => 'skyblue',
  }

  def in_same_category?(other)
    unless other.kind_of?(Position)
      raise ArgumentError, "Argument other must be a Position (#{other.class} given)"
    end

    return self.category == other.category
  end

  def color
    return CATEGORY_COLOR[category]
  end
end

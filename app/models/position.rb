class Position < ActiveRecord::Base

  def self.categories
    return find(:all, :select => 'DISTINCT category').map(&:category)
  end
end

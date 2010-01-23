class Series < ActiveRecord::Base

  def self.premier_all
    hash_order = {
      "Premier"    => 1,
      "FA Cup"     => 2,
      "L. Cup"     => 3,
      "UEFA CL"    => 4,
      "UEFA EL"    => 5,
      "UEFA SC"    => 6,
      "C. Shield"  => 7,
    }
    series = find(:all, :conditions => ["abbr in (?)", hash_order.keys])
    series.sort! { |s1, s2| hash_order[s1.abbr].<=>(hash_order[s2.abbr]) }
    return series
  end
end

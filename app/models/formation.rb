class Formation < ActiveRecord::Base

  validates_uniqueness_of :name

  def self.position_column_name(index)
    return "position%02d_id" % index
  end

  def position(index)
    position_id = self[Formation.position_column_name(index)]
    return Position.find(position_id)
  end
end

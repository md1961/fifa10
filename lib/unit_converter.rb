class UnitConverter

  KG_PER_POUND = 0.454

  def self.lb2kg(lb)
    return lb * KG_PER_POUND
  end

  CM_PER_INCH   = 2.54
  INCH_PER_FEET = 12

  def self.inch2cm(inch)
    return inch * CM_PER_INCH
  end

  def self.feet2cm(feet)
    return feet * INCH_PER_FEET * CM_PER_INCH
  end

  def self.feet_inch2cm(feet, inch)
    return feet2cm(feet) + inch2cm(inch)
  end
end

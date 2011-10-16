
class Constant
  YML_FILENAME = "#{Rails.root}/lib/constant.yml"

  def self.get(key)
    y = yaml
    y[key.to_s]
  end

  def self.yaml
    YAML.load_file(YML_FILENAME)
  end
  private_class_method :yaml

end

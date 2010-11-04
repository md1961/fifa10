require 'yaml/store'
require 'singleton'

class SimpleDB
  include Singleton

  YML_FILENAME = "#{RAILS_ROOT}/lib/simple_db.yml"

  def initialize
    @db = YAML::Store.new(YML_FILENAME)
  end

  def async
    return unless @db.kind_of?(YAML::Store)
    @db = YAML.load_file(YML_FILENAME)
    def @db.transaction
      yield
    end
  end

  def sync
    return if @db.kind_of?(YAML::Store)
    open(YML_FILENAME, 'w') do |fd|
      YAML.dump(@db, fd)
    end
  end

  def get(key)
    @db.transaction do
      @db[key]
    end
  end

  def set(key, value)
    @db.transaction do
      @db[key] = value
    end
  end
end

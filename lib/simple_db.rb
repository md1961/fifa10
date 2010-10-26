require 'yaml/store'
require 'singleton'

class SimpleDB
  include Singleton

  YML_FILENAME = "#{RAILS_ROOT}/lib/simple_db.yml"

  def initialize
    @db = YAML::Store.new(YML_FILENAME)
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

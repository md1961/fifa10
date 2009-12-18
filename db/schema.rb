# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20091218123850) do

  create_table "nations", :force => true do |t|
    t.string  "name",      :default => "", :null => false
    t.integer "region_id",                 :null => false
  end

  create_table "player_positions", :force => true do |t|
    t.integer "player_id",   :null => false
    t.integer "position_id", :null => false
  end

  create_table "players", :force => true do |t|
    t.string  "name",              :default => "", :null => false
    t.string  "first_name"
    t.integer "number",                            :null => false
    t.integer "position_id",                       :null => false
    t.integer "skill_move",                        :null => false
    t.boolean "is_right_dominant",                 :null => false
    t.integer "both_feet_level",                   :null => false
    t.integer "height",                            :null => false
    t.integer "weight",                            :null => false
    t.integer "birth_year",                        :null => false
    t.integer "nation_id",                         :null => false
    t.integer "team_id",                           :null => false
  end

  create_table "positions", :force => true do |t|
    t.string "name",     :default => "", :null => false
    t.string "category", :default => "", :null => false
  end

  create_table "regions", :force => true do |t|
    t.string "name", :default => "", :null => false
  end

  create_table "teams", :force => true do |t|
    t.string "name", :default => "", :null => false
  end

end

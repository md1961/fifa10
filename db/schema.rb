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

ActiveRecord::Schema.define(:version => 20091222234521) do

  create_table "nations", :force => true do |t|
    t.string  "name",      :default => "", :null => false
    t.integer "region_id",                 :null => false
  end

  create_table "player_attributes", :force => true do |t|
    t.integer "player_id",      :null => false
    t.integer "acceleration",   :null => false
    t.integer "positiveness",   :null => false
    t.integer "quickness",      :null => false
    t.integer "balance",        :null => false
    t.integer "control",        :null => false
    t.integer "cross",          :null => false
    t.integer "curve",          :null => false
    t.integer "dribble",        :null => false
    t.integer "goalmaking",     :null => false
    t.integer "fk_accuracy",    :null => false
    t.integer "head_accuracy",  :null => false
    t.integer "jump",           :null => false
    t.integer "long_pass",      :null => false
    t.integer "long_shot",      :null => false
    t.integer "mark",           :null => false
    t.integer "pk",             :null => false
    t.integer "positioning",    :null => false
    t.integer "reaction",       :null => false
    t.integer "short_pass",     :null => false
    t.integer "shot_power",     :null => false
    t.integer "sliding",        :null => false
    t.integer "speed",          :null => false
    t.integer "stamina",        :null => false
    t.integer "tackle",         :null => false
    t.integer "physical",       :null => false
    t.integer "tactics",        :null => false
    t.integer "vision",         :null => false
    t.integer "volley",         :null => false
    t.integer "gk_dive",        :null => false
    t.integer "gk_handling",    :null => false
    t.integer "gk_kick",        :null => false
    t.integer "gk_positioning", :null => false
    t.integer "gk_reaction",    :null => false
  end

  create_table "player_positions", :force => true do |t|
    t.integer "player_id",   :null => false
    t.integer "position_id", :null => false
  end

  create_table "player_values", :force => true do |t|
    t.integer "player_id", :null => false
    t.integer "overall",   :null => false
    t.integer "value"
    t.string  "note"
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

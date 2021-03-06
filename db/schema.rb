# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111215114755) do

  create_table "chronicles", :force => true do |t|
    t.string  "name",                      :null => false
    t.boolean "closed", :default => false
  end

  create_table "formations", :force => true do |t|
    t.string  "name",          :null => false
    t.string  "note"
    t.integer "position01_id", :null => false
    t.integer "position02_id", :null => false
    t.integer "position03_id", :null => false
    t.integer "position04_id", :null => false
    t.integer "position05_id", :null => false
    t.integer "position06_id", :null => false
    t.integer "position07_id", :null => false
    t.integer "position08_id", :null => false
    t.integer "position09_id", :null => false
    t.integer "position10_id", :null => false
    t.integer "position11_id", :null => false
  end

  add_index "formations", ["name"], :name => "index_formations_on_name", :unique => true

  create_table "matches", :force => true do |t|
    t.date    "date_match"
    t.integer "series_id"
    t.string  "subname",       :default => "",     :null => false
    t.integer "opponent_id",                       :null => false
    t.string  "ground"
    t.integer "scores_own"
    t.integer "scores_opp"
    t.integer "pks_own"
    t.integer "pks_opp"
    t.string  "scorers_own",   :default => "",     :null => false
    t.string  "scorers_opp",   :default => "",     :null => false
    t.integer "season_id",                         :null => false
    t.string  "opponent_type", :default => "Team", :null => false
  end

  add_index "matches", ["opponent_id"], :name => "fk_matches_teams"
  add_index "matches", ["season_id"], :name => "fk_matches_seasons"
  add_index "matches", ["series_id"], :name => "fk_matches_series"

  create_table "nations", :force => true do |t|
    t.string  "name",      :null => false
    t.integer "region_id", :null => false
    t.string  "code"
    t.string  "abbr"
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

  create_table "player_seasons", :force => true do |t|
    t.integer "player_id",                         :null => false
    t.integer "season_id",                         :null => false
    t.integer "order_number",                      :null => false
    t.boolean "on_loan",        :default => false, :null => false
    t.boolean "is_hot",         :default => false, :null => false
    t.boolean "is_disabled",    :default => false, :null => false
    t.date    "disabled_until"
    t.string  "diagnosis"
    t.boolean "is_not_well",    :default => false, :null => false
  end

  add_index "player_seasons", ["player_id"], :name => "fk_player_seasons_players"
  add_index "player_seasons", ["season_id", "order_number"], :name => "index_player_seasons_on_season_id_and_order_number", :unique => true

  create_table "players", :force => true do |t|
    t.string  "name",              :null => false
    t.string  "first_name"
    t.integer "number",            :null => false
    t.integer "position_id",       :null => false
    t.integer "skill_move",        :null => false
    t.boolean "is_right_dominant", :null => false
    t.integer "both_feet_level",   :null => false
    t.integer "height",            :null => false
    t.integer "weight",            :null => false
    t.integer "birth_year",        :null => false
    t.integer "nation_id",         :null => false
    t.integer "overall",           :null => false
    t.integer "market_value"
    t.string  "note"
    t.integer "wage"
    t.integer "age_add_inj"
  end

  create_table "positions", :force => true do |t|
    t.string "name",     :null => false
    t.string "category", :null => false
  end

  create_table "regions", :force => true do |t|
    t.string "name", :null => false
  end

  create_table "season_series", :force => true do |t|
    t.integer "season_id", :null => false
    t.integer "series_id", :null => false
  end

  add_index "season_series", ["season_id"], :name => "fk_season_series_seasons"
  add_index "season_series", ["series_id"], :name => "fk_season_series_series"

  create_table "seasons", :force => true do |t|
    t.integer "chronicle_id"
    t.integer "team_id"
    t.boolean "closed",                          :default => false
    t.integer "year_start",                                          :null => false
    t.string  "team_type",                       :default => "Team", :null => false
    t.integer "formation_id"
    t.integer "controller_customization_adjust"
  end

  create_table "series", :force => true do |t|
    t.string "name", :null => false
    t.string "abbr"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "teams", :force => true do |t|
    t.string  "name",         :null => false
    t.integer "year_founded"
    t.string  "ground"
    t.integer "nation_id",    :null => false
    t.string  "abbr"
    t.string  "nickname"
  end

  add_index "teams", ["nation_id"], :name => "fk_teams_nations"

  create_table "users", :force => true do |t|
    t.string   "name",                               :null => false
    t.string   "hashed_password"
    t.string   "salt"
    t.boolean  "is_writer",       :default => false, :null => false
    t.boolean  "is_admin",        :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["name"], :name => "index_users_on_name", :unique => true

end

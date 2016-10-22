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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20161022021832) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "games", force: :cascade do |t|
    t.string   "name"
    t.string   "invitation_token"
    t.string   "state"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["name", "invitation_token"], name: "index_games_on_name_and_invitation_token", using: :btree
  end

  create_table "players", force: :cascade do |t|
    t.string   "nickname"
    t.integer  "life"
    t.integer  "strike_gauge"
    t.string   "current_strike"
    t.boolean  "human",          default: false
    t.boolean  "creator",        default: false
    t.boolean  "won",            default: false
    t.integer  "game_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.index ["game_id"], name: "index_players_on_game_id", using: :btree
  end

  create_table "ships", force: :cascade do |t|
    t.integer  "damage"
    t.float    "velocity"
    t.string   "state"
    t.integer  "player_id"
    t.integer  "word_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_ships_on_player_id", using: :btree
    t.index ["word_id"], name: "index_ships_on_word_id", using: :btree
  end

  create_table "words", force: :cascade do |t|
    t.string   "value"
    t.integer  "game_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_words_on_game_id", using: :btree
    t.index ["value"], name: "index_words_on_value", using: :btree
  end

  add_foreign_key "players", "games"
  add_foreign_key "ships", "players"
  add_foreign_key "ships", "words"
  add_foreign_key "words", "games"
end

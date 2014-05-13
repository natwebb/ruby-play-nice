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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140513151300) do

  create_table "game_neighbors", force: true do |t|
    t.integer  "neighbor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "game_id"
  end

  create_table "games", force: true do |t|
    t.string   "name"
    t.string   "alt_names"
    t.integer  "base_id"
    t.string   "author"
    t.integer  "year"
    t.string   "AC"
    t.boolean  "race_as_class"
    t.integer  "saves"
    t.boolean  "skills"
    t.string   "currency"
    t.string   "init"
    t.boolean  "xp_for_gp"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end

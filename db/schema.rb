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

ActiveRecord::Schema.define(version: 20131112012225) do

  create_table "events", force: true do |t|
    t.integer  "origin_ident",           default: 0, null: false
    t.string   "name",                               null: false
    t.text     "leader_notes"
    t.datetime "starts_at",                          null: false
    t.datetime "ends_at",                            null: false
    t.string   "recurrence_description"
    t.string   "group"
    t.string   "organizer"
    t.datetime "setup_starts_at"
    t.datetime "setup_ends_at"
    t.text     "setup_notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events", ["origin_ident"], name: "index_events_on_origin_ident"
  add_index "events", ["starts_at"], name: "index_events_on_starts_at"

  create_table "resources", force: true do |t|
    t.integer  "event_id",   null: false
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "resources", ["event_id"], name: "index_resources_on_event_id"

end

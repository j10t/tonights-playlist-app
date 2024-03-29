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

ActiveRecord::Schema.define(:version => 20130923015745) do

  create_table "artists", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "eventartists", :force => true do |t|
    t.integer  "event_id"
    t.integer  "artist_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.boolean  "headliner"
  end

  add_index "eventartists", ["artist_id"], :name => "index_eventartists_on_artist_id"
  add_index "eventartists", ["event_id", "artist_id"], :name => "index_eventartists_on_event_id_and_artist_id", :unique => true
  add_index "eventartists", ["event_id"], :name => "index_eventartists_on_event_id"

  create_table "events", :force => true do |t|
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "skbuyurl"
    t.text     "additionaldetails"
    t.integer  "venue_id"
    t.datetime "datetime"
    t.string   "lat"
    t.string   "lng"
  end

  create_table "tracks", :force => true do |t|
    t.string   "source"
    t.string   "sourceid"
    t.string   "name"
    t.string   "album"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "artist_id"
  end

  create_table "venues", :force => true do |t|
    t.string   "name"
    t.string   "streetaddress"
    t.string   "city"
    t.string   "zip"
    t.string   "fulladdress"
    t.string   "url"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

end

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

ActiveRecord::Schema.define(:version => 20120823181443) do

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "notifications", :force => true do |t|
    t.integer  "truck_id"
    t.datetime "scheduled_for"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "openings", :force => true do |t|
    t.float    "lat"
    t.float    "lng"
    t.integer  "truck_id"
    t.datetime "closed_at"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "rapns_apps", :force => true do |t|
    t.string   "key",                        :null => false
    t.string   "environment",                :null => false
    t.text     "certificate",                :null => false
    t.string   "password"
    t.integer  "connections", :default => 1, :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "rapns_feedback", :force => true do |t|
    t.string   "device_token", :limit => 64, :null => false
    t.datetime "failed_at",                  :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.string   "app"
  end

  add_index "rapns_feedback", ["device_token"], :name => "index_rapns_feedback_on_device_token"

  create_table "rapns_notifications", :force => true do |t|
    t.integer  "badge"
    t.string   "device_token",          :limit => 64,                       :null => false
    t.string   "sound",                               :default => "1.aiff"
    t.string   "alert"
    t.text     "attributes_for_device"
    t.integer  "expiry",                              :default => 86400,    :null => false
    t.boolean  "delivered",                           :default => false,    :null => false
    t.datetime "delivered_at"
    t.boolean  "failed",                              :default => false,    :null => false
    t.datetime "failed_at"
    t.integer  "error_code"
    t.string   "error_description"
    t.datetime "deliver_after"
    t.datetime "created_at",                                                :null => false
    t.datetime "updated_at",                                                :null => false
    t.boolean  "alert_is_json",                       :default => false
    t.string   "app"
  end

  add_index "rapns_notifications", ["delivered", "failed", "deliver_after"], :name => "index_rapns_notifications_on_delivered_failed_deliver_after"

  create_table "trucks", :force => true do |t|
    t.string   "name"
    t.boolean  "open"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "device_token"
  end

end

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

ActiveRecord::Schema.define(:version => 20130203141520) do

  create_table "comments", :force => true do |t|
    t.text     "text"
    t.integer  "user_id"
    t.integer  "rating",          :default => 0
    t.integer  "presentation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "rated",           :default => false
  end

  create_table "conferences", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "db_files", :force => true do |t|
    t.binary "data"
  end

  create_table "invitations", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "token"
    t.datetime "sent_at"
    t.datetime "expires_at"
    t.datetime "accepted_at"
    t.boolean  "deleted"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "conference_id"
  end

  create_table "people", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "bio"
    t.integer  "conference_id"
  end

  create_table "people_presentations", :id => false, :force => true do |t|
    t.integer "person_id"
    t.integer "presentation_id"
  end

  create_table "pictures", :force => true do |t|
    t.integer  "parent_id"
    t.string   "content_type"
    t.string   "filename"
    t.string   "thumbnail"
    t.integer  "size"
    t.integer  "width"
    t.integer  "height"
    t.integer  "db_file_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "person_id"
  end

  create_table "presentation_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "presentations", :force => true do |t|
    t.string   "title"
    t.text     "abstract"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "notes"
    t.integer  "rating",               :default => 0
    t.integer  "track_id"
    t.integer  "slot_id"
    t.integer  "conference_id"
    t.integer  "presentation_type_id"
  end

  create_table "schedules", :force => true do |t|
    t.date     "start"
    t.integer  "day_count"
    t.integer  "room_count"
    t.integer  "slot_length"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "key"
    t.integer  "conference_id"
  end

  create_table "slots", :force => true do |t|
    t.date     "date"
    t.time     "start"
    t.integer  "duration"
    t.integer  "room_id"
    t.text     "text"
    t.integer  "presentation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "schedule_id"
    t.boolean  "primitive",       :default => false
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.datetime "created_at"
  end

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "tracks", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "color_style"
    t.integer  "conference_id"
  end

  create_table "users", :force => true do |t|
    t.string   "openid_url"
    t.boolean  "admin",                 :default => false
    t.string   "email_address"
    t.string   "display_name"
    t.boolean  "invited",               :default => false
    t.datetime "last_login"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "current_conference_id"
  end

end

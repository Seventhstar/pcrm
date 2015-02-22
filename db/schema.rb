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

ActiveRecord::Schema.define(version: 20150222172542) do

  create_table "budgets", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "channels", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "develops", force: :cascade do |t|
    t.string   "name"
    t.boolean  "coder"
    t.boolean  "boss"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "goodstypes", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lead_styles", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "leads", force: :cascade do |t|
    t.string   "info"
    t.string   "fio"
    t.integer  "footage"
    t.string   "phone"
    t.string   "email"
    t.integer  "channel_id"
    t.integer  "status_id"
    t.integer  "user_id"
    t.date     "status_date"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.date     "start_date"
  end

  create_table "leads_comments", force: :cascade do |t|
    t.text     "comment"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "lead_id"
  end

  create_table "provider_budgets", force: :cascade do |t|
    t.integer  "provider_id"
    t.integer  "budget_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "provider_budgets", ["budget_id"], name: "index_provider_budgets_on_budget_id"
  add_index "provider_budgets", ["provider_id"], name: "index_provider_budgets_on_provider_id"

  create_table "provider_goodstypes", force: :cascade do |t|
    t.integer  "provider_id"
    t.integer  "goodstype_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "provider_goodstypes", ["goodstype_id"], name: "index_provider_goodstypes_on_goodstype_id"
  add_index "provider_goodstypes", ["provider_id"], name: "index_provider_goodstypes_on_provider_id"

  create_table "provider_styles", force: :cascade do |t|
    t.integer  "provider_id"
    t.integer  "style_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "providers", force: :cascade do |t|
    t.string   "name"
    t.string   "manager"
    t.string   "phone"
    t.string   "komment"
    t.string   "address"
    t.string   "email"
    t.string   "url"
    t.string   "spec"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "statuses", force: :cascade do |t|
    t.string   "name"
    t.boolean  "actual"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "styles", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "password_digest"
    t.string   "remember_digest"
    t.boolean  "admin",                  default: false
    t.string   "activation_digest"
    t.boolean  "activated",              default: false
    t.datetime "activated_at"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end

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

ActiveRecord::Schema.define(version: 20170612065123) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "absence_reasons", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "absence_shop_targets", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "absence_shops", force: :cascade do |t|
    t.integer  "absence_id"
    t.integer  "shop_id"
    t.integer  "target_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "absence_targets", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "absences", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "dt_from"
    t.datetime "dt_to"
    t.integer  "reason_id"
    t.integer  "new_reason_id"
    t.text     "comment"
    t.integer  "project_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "target_id"
  end

  create_table "attachments", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "attachments", ["owner_id"], name: "index_attachments_on_owner_id", using: :btree

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

  create_table "clients", force: :cascade do |t|
    t.string   "name"
    t.string   "address"
    t.string   "phone"
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comment_unreads", force: :cascade do |t|
    t.integer  "comment_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "comment_unreads", ["comment_id"], name: "index_comment_unreads_on_comment_id", using: :btree

  create_table "comments", force: :cascade do |t|
    t.text     "comment"
    t.integer  "user_id"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dev_projects", force: :cascade do |t|
    t.string   "name"
    t.integer  "priority_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "dev_statuses", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "develops", force: :cascade do |t|
    t.string   "name"
    t.boolean  "coder"
    t.boolean  "boss"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.text     "description"
    t.integer  "project_id"
    t.integer  "priority_id"
    t.integer  "ic_user_id"
    t.integer  "dev_status_id"
  end

  add_index "develops", ["dev_status_id"], name: "index_develops_on_dev_status_id", using: :btree
  add_index "develops", ["ic_user_id"], name: "index_develops_on_ic_user_id", using: :btree
  add_index "develops", ["priority_id"], name: "index_develops_on_priority_id", using: :btree

  create_table "develops_files", force: :cascade do |t|
    t.string   "develop_id"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "develops_files", ["develop_id"], name: "index_develops_files_on_develop_id", using: :btree

  create_table "elongation_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "goodstypes", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean  "default"
  end

  create_table "holidays", force: :cascade do |t|
    t.string   "name"
    t.date     "day"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lead_sources", force: :cascade do |t|
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
    t.string   "address"
    t.integer  "ic_user_id"
    t.integer  "source_id"
  end

  add_index "leads", ["ic_user_id"], name: "index_leads_on_ic_user_id", using: :btree
  add_index "leads", ["status_id"], name: "index_leads_on_status_id", using: :btree

  create_table "leads_comments", force: :cascade do |t|
    t.text     "comment"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "lead_id"
  end

  create_table "leads_files", force: :cascade do |t|
    t.string   "name"
    t.integer  "lead_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "p_statuses", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payment_purposes", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payment_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payments", force: :cascade do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.integer  "whom_id"
    t.string   "whom_type"
    t.integer  "payment_type_id"
    t.integer  "payment_purpose_id"
    t.date     "date"
    t.integer  "sum"
    t.boolean  "verified",           default: false
    t.string   "description"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  create_table "priorities", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "project_elongations", force: :cascade do |t|
    t.date     "new_date"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "project_id"
    t.integer  "elongation_type_id"
  end

  add_index "project_elongations", ["project_id"], name: "index_project_elongations_on_project_id", using: :btree

  create_table "project_g_types", force: :cascade do |t|
    t.integer  "g_type_id"
    t.integer  "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "project_goods", force: :cascade do |t|
    t.integer  "project_g_type_id"
    t.string   "name"
    t.integer  "provider_id"
    t.date     "date_supply"
    t.text     "description"
    t.boolean  "order"
    t.integer  "currency_id"
    t.integer  "gsum"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.date     "date_offer"
    t.date     "date_place"
  end

  create_table "project_statuses", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "project_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "projects", force: :cascade do |t|
    t.integer  "client_id"
    t.integer  "number"
    t.date     "date_sign"
    t.string   "address"
    t.integer  "owner_id"
    t.integer  "executor_id"
    t.integer  "designer_id"
    t.integer  "project_type_id"
    t.integer  "style_id"
    t.date     "date_start"
    t.date     "date_end_plan"
    t.date     "date_end_real"
    t.float    "footage",            default: 0.0
    t.float    "footage_2",          default: 0.0
    t.float    "footage_real",       default: 0.0
    t.float    "footage_2_real",     default: 0.0
    t.integer  "price",              default: 0
    t.integer  "price_2",            default: 0
    t.integer  "price_real",         default: 0
    t.integer  "price_2_real",       default: 0
    t.integer  "sum",                default: 0
    t.integer  "sum_2",              default: 0
    t.integer  "sum_real",           default: 0
    t.integer  "sum_2_real",         default: 0
    t.integer  "sum_total",          default: 0
    t.integer  "sum_total_real",     default: 0
    t.integer  "month_in_gift"
    t.boolean  "act"
    t.integer  "delay_days"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "pstatus_id"
    t.boolean  "attention"
    t.integer  "designer_price"
    t.integer  "designer_price_2"
    t.integer  "visualer_price"
    t.integer  "visualer_id"
    t.boolean  "debt"
    t.boolean  "interest"
    t.boolean  "payd_q"
    t.integer  "sum_total_executor"
    t.integer  "designer_sum"
    t.integer  "visualer_sum"
    t.boolean  "payd_full"
  end

  create_table "provider_budgets", force: :cascade do |t|
    t.integer  "provider_id"
    t.integer  "budget_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "provider_budgets", ["budget_id"], name: "index_provider_budgets_on_budget_id", using: :btree
  add_index "provider_budgets", ["provider_id"], name: "index_provider_budgets_on_provider_id", using: :btree

  create_table "provider_goodstypes", force: :cascade do |t|
    t.integer  "provider_id"
    t.integer  "goodstype_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "provider_goodstypes", ["goodstype_id"], name: "index_provider_goodstypes_on_goodstype_id", using: :btree
  add_index "provider_goodstypes", ["provider_id"], name: "index_provider_goodstypes_on_provider_id", using: :btree

  create_table "provider_managers", force: :cascade do |t|
    t.string   "name"
    t.string   "phone"
    t.string   "email"
    t.integer  "provider_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "provider_managers", ["provider_id"], name: "index_provider_managers_on_provider_id", using: :btree

  create_table "provider_styles", force: :cascade do |t|
    t.integer  "provider_id"
    t.integer  "style_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "provider_styles", ["provider_id"], name: "index_provider_styles_on_provider_id", using: :btree
  add_index "provider_styles", ["style_id"], name: "index_provider_styles_on_style_id", using: :btree

  create_table "providers", force: :cascade do |t|
    t.string   "name"
    t.string   "manager"
    t.string   "phone"
    t.string   "komment"
    t.string   "address"
    t.string   "email"
    t.string   "url"
    t.string   "spec"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "p_status_id"
  end

  create_table "receipts", force: :cascade do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.integer  "provider_id"
    t.integer  "payment_type_id"
    t.date     "date"
    t.integer  "sum"
    t.string   "description"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.boolean  "paid",            default: false
    t.integer  "payment_id"
  end

  add_index "receipts", ["paid"], name: "index_receipts_on_paid", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name"
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

  create_table "user_options", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "option_id"
    t.string   "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_roles", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "role_id"
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
    t.datetime "date_birth"
    t.string   "avatar"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",      null: false
    t.integer  "item_id",        null: false
    t.string   "event",          null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.text     "object_changes"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

  create_table "wiki_cats", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "wiki_files", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "wiki_record_id"
    t.string   "name"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "wiki_files", ["wiki_record_id"], name: "index_wiki_files_on_wiki_record_id", using: :btree

  create_table "wiki_records", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "parent_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.boolean  "admin",       default: false
    t.integer  "wiki_cat_id"
  end

  add_index "wiki_records", ["wiki_cat_id"], name: "index_wiki_records_on_wiki_cat_id", using: :btree

end

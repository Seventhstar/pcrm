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

ActiveRecord::Schema.define(version: 201904215002649) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "absence_reasons", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "absence_shop_targets", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "absence_shops", id: :serial, force: :cascade do |t|
    t.integer "absence_id"
    t.integer "shop_id"
    t.integer "target_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "absence_targets", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "absences", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.datetime "dt_from"
    t.datetime "dt_to"
    t.integer "reason_id"
    t.integer "new_reason_id"
    t.text "comment"
    t.integer "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "target_id"
    t.boolean "canceled"
    t.boolean "approved", default: false
  end

  create_table "attachments", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "owner_id"
    t.string "owner_type"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "secret"
    t.index ["owner_id"], name: "index_attachments_on_owner_id"
  end

  create_table "budgets", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "channels", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cities", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "clients", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "phone"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "city_id", default: 1
    t.index ["city_id"], name: "index_clients_on_city_id"
  end

  create_table "comment_unreads", id: :serial, force: :cascade do |t|
    t.integer "comment_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["comment_id"], name: "index_comment_unreads_on_comment_id"
  end

  create_table "comments", id: :serial, force: :cascade do |t|
    t.text "comment"
    t.integer "user_id"
    t.integer "owner_id"
    t.string "owner_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "consumptions", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contact_kinds", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contacts", force: :cascade do |t|
    t.string "val"
    t.string "who"
    t.string "contactable_type"
    t.bigint "contactable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contactable_id", "contactable_type"], name: "index_contacts_on_contactable_id_and_contactable_type"
    t.index ["contactable_type", "contactable_id"], name: "index_contacts_on_contactable_type_and_contactable_id"
  end

  create_table "costing_rooms", force: :cascade do |t|
    t.bigint "costing_id"
    t.bigint "room_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["costing_id"], name: "index_costing_rooms_on_costing_id"
    t.index ["room_id"], name: "index_costing_rooms_on_room_id"
  end

  create_table "costing_works", force: :cascade do |t|
    t.bigint "costing_id"
    t.bigint "work_id"
    t.bigint "room_id"
    t.integer "step"
    t.integer "qty"
    t.float "price"
    t.integer "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["costing_id"], name: "index_costing_works_on_costing_id"
    t.index ["room_id"], name: "index_costing_works_on_room_id"
    t.index ["work_id"], name: "index_costing_works_on_work_id"
  end

  create_table "costings", force: :cascade do |t|
    t.bigint "project_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "costings_type_id"
    t.date "date_create"
    t.index ["costings_type_id"], name: "index_costings_on_costings_type_id"
    t.index ["project_id"], name: "index_costings_on_project_id"
    t.index ["user_id"], name: "index_costings_on_user_id"
  end

  create_table "costings_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "currencies", force: :cascade do |t|
    t.string "name"
    t.string "short"
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "delivery_times", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "priority", default: 100
  end

  create_table "dev_projects", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "priority_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dev_statuses", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "develops", id: :serial, force: :cascade do |t|
    t.string "name"
    t.boolean "coder"
    t.boolean "boss"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.integer "project_id"
    t.integer "priority_id"
    t.integer "ic_user_id"
    t.integer "dev_status_id"
    t.index ["dev_status_id"], name: "index_develops_on_dev_status_id"
    t.index ["ic_user_id"], name: "index_develops_on_ic_user_id"
    t.index ["priority_id"], name: "index_develops_on_priority_id"
  end

  create_table "develops_files", id: :serial, force: :cascade do |t|
    t.string "develop_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["develop_id"], name: "index_develops_files_on_develop_id"
  end

  create_table "elongation_types", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "goods_priorities", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "goodstypes", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "default"
    t.integer "priority", default: 100
  end

  create_table "holidays", id: :serial, force: :cascade do |t|
    t.string "name"
    t.date "day"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lead_sources", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "leads", id: :serial, force: :cascade do |t|
    t.string "info"
    t.string "fio"
    t.integer "footage"
    t.string "phone"
    t.string "email"
    t.integer "channel_id"
    t.integer "status_id"
    t.integer "user_id"
    t.date "status_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "start_date"
    t.string "address"
    t.integer "ic_user_id"
    t.integer "source_id"
    t.bigint "priority_id"
    t.bigint "city_id", default: 1
    t.index ["city_id"], name: "index_leads_on_city_id"
    t.index ["ic_user_id"], name: "index_leads_on_ic_user_id"
    t.index ["priority_id"], name: "index_leads_on_priority_id"
    t.index ["status_id"], name: "index_leads_on_status_id"
  end

  create_table "leads_comments", id: :serial, force: :cascade do |t|
    t.text "comment"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "lead_id"
  end

  create_table "leads_files", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "lead_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "materials", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "p_statuses", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payment_purposes", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payment_types", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payments", id: :serial, force: :cascade do |t|
    t.integer "project_id"
    t.integer "user_id"
    t.integer "whom_id"
    t.string "whom_type"
    t.integer "payment_type_id"
    t.integer "payment_purpose_id"
    t.date "date"
    t.integer "sum"
    t.boolean "verified", default: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "positions", force: :cascade do |t|
    t.string "name"
    t.boolean "secret", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "priorities", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "project_conditions", force: :cascade do |t|
    t.boolean "closed"
    t.bigint "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_project_conditions_on_project_id"
  end

  create_table "project_elongations", id: :serial, force: :cascade do |t|
    t.date "new_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "project_id"
    t.integer "elongation_type_id"
    t.index ["project_id"], name: "index_project_elongations_on_project_id"
  end

  create_table "project_g_types", id: :serial, force: :cascade do |t|
    t.integer "g_type_id"
    t.integer "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["g_type_id"], name: "index_project_g_types_on_g_type_id"
    t.index ["project_id"], name: "index_project_g_types_on_project_id"
  end

  create_table "project_goods", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "provider_id"
    t.date "date_supply"
    t.text "description"
    t.boolean "order", default: false
    t.integer "currency_id"
    t.integer "gsum"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "date_offer"
    t.date "date_place"
    t.integer "sum_supply"
    t.boolean "fixed", default: false
    t.integer "project_id"
    t.integer "goodstype_id"
    t.integer "project_g_type_id"
    t.bigint "goods_priority_id", default: 1
    t.bigint "delivery_time_id", default: 1
    t.index ["delivery_time_id"], name: "index_project_goods_on_delivery_time_id"
    t.index ["fixed"], name: "index_project_goods_on_fixed"
    t.index ["goods_priority_id"], name: "index_project_goods_on_goods_priority_id"
    t.index ["goodstype_id"], name: "index_project_goods_on_goodstype_id"
    t.index ["project_id"], name: "index_project_goods_on_project_id"
  end

  create_table "project_statuses", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "color"
  end

  create_table "project_types", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "simple", default: false
  end

  create_table "projects", id: :serial, force: :cascade do |t|
    t.integer "client_id"
    t.integer "number"
    t.date "date_sign"
    t.string "address"
    t.integer "owner_id"
    t.integer "executor_id"
    t.integer "designer_id"
    t.integer "project_type_id"
    t.integer "style_id"
    t.date "date_start"
    t.date "date_end_plan"
    t.date "date_end_real"
    t.float "footage", default: 0.0
    t.float "footage_2", default: 0.0
    t.float "footage_real", default: 0.0
    t.float "footage_2_real", default: 0.0
    t.integer "price", default: 0
    t.integer "price_2", default: 0
    t.integer "price_real", default: 0
    t.integer "price_2_real", default: 0
    t.integer "sum", default: 0
    t.integer "sum_2", default: 0
    t.integer "sum_real", default: 0
    t.integer "sum_2_real", default: 0
    t.integer "sum_total", default: 0
    t.integer "sum_total_real", default: 0
    t.integer "month_in_gift"
    t.boolean "act"
    t.integer "delay_days"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "pstatus_id"
    t.boolean "attention"
    t.integer "designer_price"
    t.integer "designer_price_2"
    t.integer "visualer_price"
    t.integer "visualer_id"
    t.boolean "debt"
    t.boolean "interest"
    t.boolean "payd_q"
    t.integer "sum_total_executor"
    t.integer "designer_sum"
    t.integer "visualer_sum"
    t.boolean "payd_full"
    t.integer "progress"
    t.integer "sum_discount", default: 0
    t.bigint "city_id", default: 1
    t.bigint "lead_id"
    t.index ["city_id"], name: "index_projects_on_city_id"
    t.index ["lead_id"], name: "index_projects_on_lead_id"
  end

  create_table "provider_budgets", id: :serial, force: :cascade do |t|
    t.integer "provider_id"
    t.integer "budget_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["budget_id"], name: "index_provider_budgets_on_budget_id"
    t.index ["provider_id"], name: "index_provider_budgets_on_provider_id"
  end

  create_table "provider_goodstypes", id: :serial, force: :cascade do |t|
    t.integer "provider_id"
    t.integer "goodstype_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["goodstype_id"], name: "index_provider_goodstypes_on_goodstype_id"
    t.index ["provider_id"], name: "index_provider_goodstypes_on_provider_id"
  end

  create_table "provider_managers", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "phone"
    t.string "email"
    t.integer "provider_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "position_id", default: 2
    t.index ["position_id"], name: "index_provider_managers_on_position_id"
    t.index ["provider_id"], name: "index_provider_managers_on_provider_id"
  end

  create_table "provider_styles", id: :serial, force: :cascade do |t|
    t.integer "provider_id"
    t.integer "style_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["provider_id"], name: "index_provider_styles_on_provider_id"
    t.index ["style_id"], name: "index_provider_styles_on_style_id"
  end

  create_table "providers", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "manager"
    t.string "phone"
    t.string "komment"
    t.string "address"
    t.string "email"
    t.string "url"
    t.string "spec"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "p_status_id"
    t.bigint "city_id", default: 1
    t.index ["city_id"], name: "index_providers_on_city_id"
  end

  create_table "receipts", id: :serial, force: :cascade do |t|
    t.integer "project_id"
    t.integer "user_id"
    t.integer "provider_id"
    t.integer "payment_type_id"
    t.date "date"
    t.integer "sum"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "paid", default: false
    t.integer "payment_id"
    t.index ["paid"], name: "index_receipts_on_paid"
  end

  create_table "roles", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "room_works", force: :cascade do |t|
    t.bigint "room_id"
    t.bigint "work_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_room_works_on_room_id"
    t.index ["work_id"], name: "index_room_works_on_work_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "special_infos", force: :cascade do |t|
    t.text "content"
    t.string "specialable_type"
    t.bigint "specialable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["specialable_id", "specialable_type"], name: "index_special_infos_on_specialable_id_and_specialable_type"
    t.index ["specialable_type", "specialable_id"], name: "index_special_infos_on_specialable_type_and_specialable_id"
  end

  create_table "statuses", id: :serial, force: :cascade do |t|
    t.string "name"
    t.boolean "actual"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "styles", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tarif_calc_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tarifs", force: :cascade do |t|
    t.bigint "project_type_id"
    t.integer "sum"
    t.integer "sum2"
    t.bigint "tarif_calc_type_id"
    t.integer "from"
    t.float "designer_price"
    t.integer "designer_price2"
    t.integer "vis_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_type_id"], name: "index_tarifs_on_project_type_id"
    t.index ["tarif_calc_type_id"], name: "index_tarifs_on_tarif_calc_type_id"
  end

  create_table "uoms", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_options", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "option_id"
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_roles", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_urls", force: :cascade do |t|
    t.string "model"
    t.text "params"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "password_digest"
    t.string "remember_digest"
    t.boolean "admin", default: false
    t.string "activation_digest"
    t.boolean "activated", default: false
    t.datetime "activated_at"
    t.string "reset_digest"
    t.datetime "reset_sent_at"
    t.datetime "date_birth"
    t.string "avatar"
    t.string "telegram"
    t.boolean "fired", default: false
    t.bigint "city_id", default: 1
    t.index ["city_id"], name: "index_users_on_city_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "versions", id: :serial, force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.text "object_changes"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  create_table "wiki_cats", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "wiki_files", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "wiki_record_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["wiki_record_id"], name: "index_wiki_files_on_wiki_record_id"
  end

  create_table "wiki_records", id: :serial, force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false
    t.integer "wiki_cat_id"
    t.index ["wiki_cat_id"], name: "index_wiki_records_on_wiki_cat_id"
  end

  create_table "work_linkers", force: :cascade do |t|
    t.bigint "work_id"
    t.bigint "linked_work_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["linked_work_id"], name: "index_work_linkers_on_linked_work_id"
    t.index ["work_id", "linked_work_id"], name: "index_work_linkers_on_work_id_and_linked_work_id", unique: true
    t.index ["work_id"], name: "index_work_linkers_on_work_id"
  end

  create_table "work_types", force: :cascade do |t|
    t.string "name"
    t.integer "comission"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "working_days", force: :cascade do |t|
    t.date "day"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "works", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "work_type_id"
    t.bigint "uom_id"
    t.index ["uom_id"], name: "index_works_on_uom_id"
  end

  add_foreign_key "clients", "cities"
  add_foreign_key "costing_rooms", "costings"
  add_foreign_key "costing_rooms", "rooms"
  add_foreign_key "costing_works", "costings"
  add_foreign_key "costing_works", "rooms"
  add_foreign_key "costing_works", "works"
  add_foreign_key "costings", "costings_types"
  add_foreign_key "costings", "projects"
  add_foreign_key "costings", "users"
  add_foreign_key "leads", "cities"
  add_foreign_key "leads", "priorities"
  add_foreign_key "project_goods", "delivery_times"
  add_foreign_key "project_goods", "goods_priorities"
  add_foreign_key "project_goods", "goodstypes"
  add_foreign_key "project_goods", "projects"
  add_foreign_key "projects", "cities"
  add_foreign_key "projects", "leads"
  add_foreign_key "provider_managers", "positions"
  add_foreign_key "providers", "cities"
  add_foreign_key "room_works", "rooms"
  add_foreign_key "room_works", "works"
  add_foreign_key "tarifs", "project_types"
  add_foreign_key "tarifs", "tarif_calc_types"
  add_foreign_key "users", "cities"
  add_foreign_key "works", "uoms"
end

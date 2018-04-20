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

ActiveRecord::Schema.define(version: 2018_04_19_121148) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "admins", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "disputes", force: :cascade do |t|
    t.text "comment"
    t.bigint "pledge_id"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pledge_id"], name: "index_disputes_on_pledge_id"
  end

  create_table "linked_accounts", force: :cascade do |t|
    t.string "provider"
    t.string "uid"
    t.string "link"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "profile_pic"
    t.string "email"
    t.index ["user_id"], name: "index_linked_accounts_on_user_id"
  end

  create_table "pledges", force: :cascade do |t|
    t.decimal "amount", precision: 8, scale: 2
    t.bigint "donor_id"
    t.integer "status", default: 0
    t.bigint "request_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "read_terms", default: false
    t.datetime "confirmed_at"
    t.index ["donor_id"], name: "index_pledges_on_donor_id"
    t.index ["request_id"], name: "index_pledges_on_request_id"
  end

  create_table "reports", force: :cascade do |t|
    t.bigint "reporter_id"
    t.bigint "reported_id"
    t.text "reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reported_id"], name: "index_reports_on_reported_id"
    t.index ["reporter_id", "reported_id"], name: "index_reports_on_reporter_id_and_reported_id", unique: true
    t.index ["reporter_id"], name: "index_reports_on_reporter_id"
  end

  create_table "requests", force: :cascade do |t|
    t.string "bank_name"
    t.string "account_number"
    t.string "account_name"
    t.text "description"
    t.string "transport_type"
    t.string "to_city"
    t.string "to_state"
    t.decimal "travelling_fees", precision: 8, scale: 2, default: "0.0"
    t.decimal "target_amount", precision: 8, scale: 2, default: "0.0"
    t.bigint "requester_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "itinerary"
    t.string "travel_company"
    t.decimal "remaining_balance", precision: 8
    t.datetime "disabled_at"
    t.decimal "total_received", precision: 8, scale: 3, default: "0.0"
    t.index ["disabled_at"], name: "index_requests_on_disabled_at"
    t.index ["requester_id"], name: "index_requests_on_requester_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "hashed_phone"
    t.datetime "phone_verified_at"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "profile_pic"
    t.string "unconfirmed_email"
    t.string "email"
    t.string "phone_number"
    t.string "phone_area_code"
    t.string "confirmation_token"
    t.datetime "confirmation_sent_at"
    t.datetime "confirmed_at"
    t.boolean "email_public", default: false
    t.string "ic"
    t.boolean "read_terms", default: false
    t.boolean "flagged", default: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["ic"], name: "index_users_on_ic", unique: true
  end

  add_foreign_key "disputes", "pledges"
  add_foreign_key "linked_accounts", "users"
  add_foreign_key "pledges", "requests"
end

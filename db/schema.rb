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

ActiveRecord::Schema.define(version: 20151006160934) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "appraisal_categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "label"
    t.integer  "weight",     default: 50, null: false
  end

  create_table "appraisal_categories_template_fields", force: true do |t|
    t.integer "appraisal_category_id"
    t.integer "template_field_id"
  end

  create_table "appraisal_categories_templates", force: true do |t|
    t.integer "appraisal_category_id"
    t.integer "appraisal_template_id"
  end

  create_table "appraisal_column_template_fields", force: true do |t|
    t.integer  "appraisal_column_id"
    t.integer  "template_field_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "appraisal_column_template_fields", ["appraisal_column_id", "template_field_id"], name: "index_appraisal_column_template_field", using: :btree

  create_table "appraisal_columns", force: true do |t|
    t.string   "column_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "static_fields"
    t.integer  "organization_id"
  end

  create_table "appraisal_entries", force: true do |t|
    t.text     "value"
    t.integer  "appraisal_id"
    t.integer  "template_field_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "numeric"
    t.datetime "deleted_at"
  end

  add_index "appraisal_entries", ["appraisal_id"], name: "index_appraisal_entries_on_appraisal_id", using: :btree
  add_index "appraisal_entries", ["deleted_at"], name: "index_appraisal_entries_on_deleted_at", using: :btree
  add_index "appraisal_entries", ["template_field_id"], name: "index_appraisal_entries_on_template_field_id", using: :btree

  create_table "appraisal_templates", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "label"
    t.boolean  "agent",             default: false, null: false
    t.integer  "equipment_type_id"
  end

  create_table "appraisal_templates_organizations", force: true do |t|
    t.integer "organization_id"
    t.integer "appraisal_template_id"
    t.boolean "is_visible",            default: true
  end

  create_table "appraisal_user_pins", force: true do |t|
    t.integer  "appraisal_id"
    t.integer  "user_id"
    t.integer  "appraisal_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "appraisal_user_pins", ["appraisal_id", "user_id"], name: "index_appraisal_user_pins_on_appraisal_id_and_user_id", using: :btree

  create_table "appraisals", force: true do |t|
    t.string   "number"
    t.string   "status"
    t.string   "unit"
    t.integer  "user_id"
    t.integer  "customer_id"
    t.integer  "appraisal_template_id"
    t.integer  "organization_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.boolean  "archived",              default: false, null: false
    t.string   "slug"
  end

  add_index "appraisals", ["slug"], name: "index_appraisals_on_slug", using: :btree

  create_table "attachments", force: true do |t|
    t.integer  "attachable_id"
    t.string   "attachable_type"
    t.string   "file_name"
    t.string   "file_url"
    t.string   "file_size"
    t.string   "file_type"
    t.integer  "uploaded_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "auth_tokens", force: true do |t|
    t.integer  "user_id"
    t.text     "token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "auth_tokens", ["token"], name: "index_auth_tokens_on_token", unique: true, using: :btree

  create_table "checklist_items", force: true do |t|
    t.integer  "checklist_id"
    t.string   "description"
    t.boolean  "completed",    default: false
    t.integer  "creator_id"
    t.integer  "owner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "completed_at"
  end

  add_index "checklist_items", ["completed_at"], name: "index_checklist_items_on_completed_at", using: :btree

  create_table "checklists", force: true do |t|
    t.string   "name"
    t.integer  "creator_id"
    t.integer  "appraisal_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: true do |t|
    t.string   "title",            limit: 50, default: ""
    t.text     "comment"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "user_id"
    t.string   "role",                        default: "comments"
    t.boolean  "hidden",                      default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "price"
    t.string   "state_of_sale"
    t.datetime "revealed_at"
    t.integer  "revealed_by"
  end

  add_index "comments", ["commentable_id"], name: "index_comments_on_commentable_id", using: :btree
  add_index "comments", ["commentable_type"], name: "index_comments_on_commentable_type", using: :btree
  add_index "comments", ["revealed_at"], name: "index_comments_on_revealed_at", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "customers", force: true do |t|
    t.string   "account_name"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "business_phone"
    t.string   "direct_phone"
    t.string   "street_address"
    t.string   "city"
    t.string   "state_or_provence"
    t.string   "postal_code"
    t.string   "mobile_phone"
    t.integer  "organization_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "archived",          default: false, null: false
  end

  create_table "discussions", force: true do |t|
    t.string   "name"
    t.integer  "appraisal_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "email_templates", force: true do |t|
    t.string   "name"
    t.text     "subject"
    t.text     "body"
    t.boolean  "is_active"
    t.text     "purpose_trigger_action"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "equipment_types", force: true do |t|
    t.string   "name"
    t.string   "label"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "can_be_converted_to_ids"
  end

  create_table "field_access_controls", force: true do |t|
    t.integer "organization_id"
    t.integer "template_field_id"
    t.string  "view_permission",   default: true, null: false
    t.string  "edit_permission",   default: true, null: false
    t.string  "label"
    t.string  "print_label"
    t.text    "choices"
  end

  add_index "field_access_controls", ["organization_id", "template_field_id"], name: "field_access_control_index", unique: true, using: :btree

  create_table "memberships", force: true do |t|
    t.integer  "organization_id"
    t.integer  "user_id"
    t.boolean  "owner",                  default: false, null: false
    t.integer  "role_id"
    t.string   "job_title"
    t.string   "email"
    t.string   "contact_phone"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "invitation_token"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_created_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invited_by"
    t.integer  "invitation_limit"
    t.integer  "invitations_count",      default: 0
    t.boolean  "active",                 default: true
  end

  add_index "memberships", ["invitation_token"], name: "index_memberships_on_invitation_token", unique: true, using: :btree
  add_index "memberships", ["invitations_count"], name: "index_memberships_on_invitations_count", using: :btree
  add_index "memberships", ["organization_id", "user_id"], name: "index_memberships_on_organization_id_and_user_id", unique: true, using: :btree

  create_table "organization_equipment_types", force: true do |t|
    t.integer  "organization_id"
    t.integer  "equipment_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "user_creatable",    default: true
  end

  create_table "organizations", force: true do |t|
    t.string   "name"
    t.integer  "appraisal_sequence",        default: 0
    t.string   "acronym"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "plan_name"
    t.text     "plan_comments"
    t.string   "plan_pricing"
    t.string   "trade_name"
    t.string   "street_address"
    t.string   "city"
    t.string   "state"
    t.string   "zipcode"
    t.string   "call_to_action"
    t.string   "sale_sheet_phone"
    t.string   "toll_free"
    t.string   "main"
    t.string   "sales"
    t.string   "service"
    t.string   "parts"
    t.text     "commentary"
    t.string   "location"
    t.text     "sale_term_conditions"
    t.string   "company_logo_file_name"
    t.string   "company_logo_content_type"
    t.integer  "company_logo_file_size"
    t.datetime "company_logo_updated_at"
    t.string   "map_image_file_name"
    t.string   "map_image_content_type"
    t.integer  "map_image_file_size"
    t.datetime "map_image_updated_at"
    t.text     "warranty"
    t.text     "term_guidelines"
    t.text     "internal_trade_policy"
    t.string   "email_suffix"
    t.integer  "owner_id"
    t.integer  "admin_id"
    t.string   "slug"
    t.boolean  "is_equipment_type_enabled"
  end

  add_index "organizations", ["slug"], name: "index_organizations_on_slug", using: :btree

  create_table "print_template_blocks", force: true do |t|
    t.integer  "print_template_id"
    t.integer  "page"
    t.string   "section"
    t.integer  "blockable_id"
    t.string   "blockable_type"
    t.json     "properties"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "print_template_blocks", ["blockable_id", "blockable_type"], name: "index_print_template_blocks_on_blockable_id_and_blockable_type", using: :btree

  create_table "print_templates", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "appraisal_template_id"
    t.string   "layout_type"
  end

  create_table "roles", force: true do |t|
    t.string   "name"
    t.string   "profile"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "settings", force: true do |t|
    t.integer  "organization_id"
    t.string   "header_color"
    t.string   "sub_header_color"
    t.string   "sub_background_color"
    t.string   "text_color",           default: "black"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "body_text_color",      default: "#000"
    t.string   "highlight_line_color", default: "#000"
    t.string   "comment_text_color",   default: "#000"
  end

  create_table "template_fields", force: true do |t|
    t.string   "name"
    t.string   "field_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "label"
    t.text     "choices"
    t.boolean  "required",                   default: false, null: false
    t.text     "formatting"
    t.integer  "weight",                                     null: false
    t.boolean  "cloneable",                  default: true,  null: false
    t.string   "print_label"
    t.boolean  "has_effect_on_other_fields", default: false
    t.boolean  "editable_by_user",           default: true
    t.boolean  "has_access_control"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "invitations_count",      default: 0
    t.boolean  "admin",                  default: false, null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "street_address"
    t.string   "city"
    t.string   "state"
    t.string   "postal_code"
    t.string   "business_phone"
    t.string   "mobile_phone"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.boolean  "active",                 default: true
    t.boolean  "archived",               default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["invitations_count"], name: "index_users_on_invitations_count", using: :btree
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "valuation_urls", force: true do |t|
    t.integer  "appraisal_id"
    t.integer  "user_id"
    t.string   "url"
    t.string   "year"
    t.string   "make"
    t.string   "model"
    t.float    "retail_value"
    t.float    "wholesale_value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "valuations", force: true do |t|
    t.string  "requested_value"
    t.string  "approved_value"
    t.string  "estimated_reconditioning"
    t.string  "approved_reconditioning"
    t.string  "proposed_retail"
    t.string  "approved_retail"
    t.string  "approved_good_until_date"
    t.string  "expected_acquisition_date"
    t.integer "appraisal_id"
    t.text    "trade_conditions"
  end

  create_table "versions", force: true do |t|
    t.string   "item_type",      null: false
    t.integer  "item_id",        null: false
    t.string   "event",          null: false
    t.string   "whodunnit"
    t.json     "object"
    t.json     "object_changes"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

end

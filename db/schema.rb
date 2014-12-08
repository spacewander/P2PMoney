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

ActiveRecord::Schema.define(version: 20141208023342) do

  create_table "investments", force: true do |t|
    t.integer  "debit_id",    null: false
    t.integer  "investor_id", null: false
    t.date     "invest_date", null: false
    t.boolean  "is_repay",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "loans", force: true do |t|
    t.integer  "debit_id",                                  null: false
    t.integer  "investor_id",                               null: false
    t.decimal  "amount",           precision: 12, scale: 2
    t.date     "loan_time",                                 null: false
    t.date     "repay_time",                                null: false
    t.string   "bank_card_num",                             null: false
    t.date     "filing_date",                               null: false
    t.boolean  "is_invested",                               null: false
    t.boolean  "is_repay",                                  null: false
    t.date     "final_repay_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rates", force: true do |t|
    t.decimal  "interest_rate", precision: 4, scale: 2, default: 5.0
    t.integer  "months",                                              null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "username",                                             null: false
    t.string   "password_hash",                                        null: false
    t.string   "telephone",                                            null: false
    t.string   "email",                                                null: false
    t.string   "real_name",                                            null: false
    t.string   "id_card_num",                                          null: false
    t.decimal  "balance",       precision: 12, scale: 2, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end

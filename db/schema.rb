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

ActiveRecord::Schema.define(version: 2018_12_07_032111) do

  create_table "card_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_card_types_on_name", unique: true
  end

  create_table "cards", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.text "description", null: false
    t.string "patch", null: false
    t.integer "card_type_id", null: false
    t.integer "stars", null: false
    t.integer "top", null: false
    t.integer "right", null: false
    t.integer "bottom", null: false
    t.integer "left", null: false
    t.integer "buy_price"
    t.integer "sell_price", null: false
    t.string "source"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["card_type_id"], name: "index_cards_on_card_type_id"
    t.index ["name"], name: "index_cards_on_name", unique: true
  end

  create_table "npc_cards", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "npc_id", null: false
    t.integer "card_id", null: false
    t.boolean "fixed", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["card_id"], name: "index_npc_cards_on_card_id"
    t.index ["npc_id"], name: "index_npc_cards_on_npc_id"
  end

  create_table "npc_rewards", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "npc_id", null: false
    t.integer "card_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["card_id"], name: "index_npc_rewards_on_card_id"
    t.index ["npc_id"], name: "index_npc_rewards_on_npc_id"
  end

  create_table "npcs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "location"
    t.integer "x"
    t.integer "y"
    t.string "rules"
    t.string "quest"
    t.integer "resident_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pack_cards", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "pack_id", null: false
    t.integer "card_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["card_id"], name: "index_pack_cards_on_card_id"
    t.index ["pack_id"], name: "index_pack_cards_on_pack_id"
  end

  create_table "packs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.integer "cost", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_packs_on_name", unique: true
  end

end

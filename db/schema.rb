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

ActiveRecord::Schema.define(version: 2019_03_03_183219) do

  create_table "card_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name_en", null: false
    t.string "name_de", null: false
    t.string "name_fr", null: false
    t.string "name_ja", null: false
    t.index ["name_de"], name: "index_card_types_on_name_de", unique: true
    t.index ["name_en"], name: "index_card_types_on_name_en", unique: true
    t.index ["name_fr"], name: "index_card_types_on_name_fr", unique: true
    t.index ["name_ja"], name: "index_card_types_on_name_ja", unique: true
  end

  create_table "cards", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "patch"
    t.integer "card_type_id", null: false
    t.integer "stars", null: false
    t.integer "top", null: false
    t.integer "right", null: false
    t.integer "bottom", null: false
    t.integer "left", null: false
    t.integer "buy_price"
    t.integer "sell_price", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sort_id"
    t.string "name_en", null: false
    t.string "name_de", null: false
    t.string "name_fr", null: false
    t.string "name_ja", null: false
    t.text "description_en", null: false
    t.text "description_de", null: false
    t.text "description_fr", null: false
    t.text "description_ja", null: false
    t.index ["card_type_id"], name: "index_cards_on_card_type_id"
    t.index ["id", "patch"], name: "index_cards_on_id_and_patch"
    t.index ["name_de"], name: "index_cards_on_name_de", unique: true
    t.index ["name_en"], name: "index_cards_on_name_en", unique: true
    t.index ["name_fr"], name: "index_cards_on_name_fr", unique: true
    t.index ["name_ja"], name: "index_cards_on_name_ja", unique: true
    t.index ["sort_id"], name: "index_cards_on_sort_id"
    t.index ["stars"], name: "index_cards_on_stars"
  end

  create_table "cards_users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_id"
    t.integer "card_id"
    t.index ["card_id"], name: "index_cards_users_on_card_id"
    t.index ["user_id", "card_id"], name: "index_cards_users_on_user_id_and_card_id", unique: true
    t.index ["user_id"], name: "index_cards_users_on_user_id"
  end

  create_table "locations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name_en", null: false
    t.string "name_de", null: false
    t.string "name_fr", null: false
    t.string "name_ja", null: false
    t.string "region_en", null: false
    t.string "region_de", null: false
    t.string "region_fr", null: false
    t.string "region_ja", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name_de"], name: "index_locations_on_name_de", unique: true
    t.index ["name_en"], name: "index_locations_on_name_en", unique: true
    t.index ["name_fr"], name: "index_locations_on_name_fr", unique: true
    t.index ["name_ja"], name: "index_locations_on_name_ja", unique: true
    t.index ["region_de"], name: "index_locations_on_region_de"
    t.index ["region_en"], name: "index_locations_on_region_en"
    t.index ["region_fr"], name: "index_locations_on_region_fr"
    t.index ["region_ja"], name: "index_locations_on_region_ja"
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
    t.integer "x"
    t.integer "y"
    t.string "quest"
    t.integer "resident_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "quest_id"
    t.string "patch"
    t.string "name_en", null: false
    t.string "name_de", null: false
    t.string "name_fr", null: false
    t.string "name_ja", null: false
    t.integer "location_id", null: false
    t.index ["location_id"], name: "index_npcs_on_location_id"
    t.index ["name_de"], name: "index_npcs_on_name_de", unique: true
    t.index ["name_en"], name: "index_npcs_on_name_en", unique: true
    t.index ["name_fr"], name: "index_npcs_on_name_fr", unique: true
    t.index ["name_ja"], name: "index_npcs_on_name_ja", unique: true
    t.index ["patch"], name: "index_npcs_on_patch"
  end

  create_table "npcs_rules", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "npc_id"
    t.integer "rule_id"
    t.index ["npc_id", "rule_id"], name: "index_npcs_rules_on_npc_id_and_rule_id", unique: true
    t.index ["npc_id"], name: "index_npcs_rules_on_npc_id"
    t.index ["rule_id"], name: "index_npcs_rules_on_rule_id"
  end

  create_table "npcs_users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_id"
    t.integer "npc_id"
    t.index ["npc_id"], name: "index_npcs_users_on_npc_id"
    t.index ["user_id", "npc_id"], name: "index_npcs_users_on_user_id_and_npc_id", unique: true
    t.index ["user_id"], name: "index_npcs_users_on_user_id"
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
    t.integer "cost", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name_en", null: false
    t.string "name_de", null: false
    t.string "name_fr", null: false
    t.string "name_ja", null: false
    t.index ["name_de"], name: "index_packs_on_name_de", unique: true
    t.index ["name_en"], name: "index_packs_on_name_en", unique: true
    t.index ["name_fr"], name: "index_packs_on_name_fr", unique: true
    t.index ["name_ja"], name: "index_packs_on_name_ja", unique: true
  end

  create_table "rules", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name_en", null: false
    t.string "name_de", null: false
    t.string "name_fr", null: false
    t.string "name_ja", null: false
    t.string "description_en", null: false
    t.string "description_de", null: false
    t.string "description_fr", null: false
    t.string "description_ja", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name_de"], name: "index_rules_on_name_de", unique: true
    t.index ["name_en"], name: "index_rules_on_name_en", unique: true
    t.index ["name_fr"], name: "index_rules_on_name_fr", unique: true
    t.index ["name_ja"], name: "index_rules_on_name_ja", unique: true
  end

  create_table "sources", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "card_id"
    t.string "origin"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["card_id"], name: "index_sources_on_card_id"
    t.index ["origin"], name: "index_sources_on_origin"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "username"
    t.integer "discriminator"
    t.string "avatar_url"
    t.string "provider"
    t.string "uid"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "public_cards", default: true
    t.boolean "admin", default: false
  end

end

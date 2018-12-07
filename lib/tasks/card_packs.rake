namespace :card_packs do
  BRONZE_CARDS = ['Spriggan', 'Pudding', 'Coblyn', 'Goobbue', 'Scarface Bugaal Ja', 'Behemoth',
                  'Magitek Death Claw', 'Liquid Flame', 'Delivery Moogle'].freeze
  SILVER_CARDS = ["Amalj'aa", 'Sylph', 'Kobold', 'Tataru Taru', 'Ixal', 'Lahabrea', 'Urianger', 'Minfilia'].freeze
  GOLD_CARDS = ['Mother Miounne', 'Momodi Modi', 'Baderon Tenfingers', 'Hoary Boulder & Coultenet', 'Gerolt',
                'Ultima Weapon', 'Cid Garlond', 'Warrior of Light', 'Zidane Tribal'].freeze
  MYTHRIL_CARDS = ['Vedrfolnir', 'Pipin Tarupin', 'Gilgamesh & Enkidu', 'Odin', 'Coeurlregina', 'Brachiosaur',
                   'Terra Branford', 'Bartz Klauser', 'Onion Knight'].freeze
  PLATINUM_CARDS = ['Tidus', 'Firion', 'Cecil Harvey', 'Lightning', 'Nanamo Ul Namo', 'Shiva', 'Lahabrea', 'Ultima Weapon'].freeze
  IMPERIAL_CARDS = ['Magitek Gunship', 'Magitek Sky Armor', 'Magitek Vanguard', 'Regula van Hydrus',
                    'Magitek Predator', 'Armored Weapon'].freeze

desc 'Create the card packs'
  task create: :environment do
    puts 'Creating card packs'
    count = Pack.count

    bronze = Pack.find_or_create_by!(name: 'Bronze Triad Card', cost: 520)
    bronze.cards = Card.where(name: BRONZE_CARDS)
    bronze.save

    silver = Pack.find_or_create_by!(name: 'Silver Triad Card', cost: 1150)
    silver.cards = Card.where(name: SILVER_CARDS)
    silver.save

    gold = Pack.find_or_create_by!(name: 'Gold Triad Card', cost: 2160)
    gold.cards = Card.where(name: GOLD_CARDS)
    gold.save

    mythril = Pack.find_or_create_by!(name: 'Mythril Triad Card', cost: 8000)
    mythril.cards = Card.where(name: MYTHRIL_CARDS)
    mythril.save

    platinum = Pack.find_or_create_by!(name: 'Platinum Triad Card', cost: 0)
    platinum.cards = Card.where(name: PLATINUM_CARDS)
    platinum.save

    imperial = Pack.find_or_create_by!(name: 'Imperial Triad Card', cost: 2160)
    imperial.cards = Card.where(name: IMPERIAL_CARDS)
    imperial.save

    puts "Created #{Pack.count - count} new card packs"
  end
end

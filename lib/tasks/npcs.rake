require 'csv'
require 'open-uri'

namespace :npcs do
  desc 'Create the NPCs'
  task create: :environment do
    puts 'Creating NPCs'
    counts = { npc: NPC.count, npc_card: NPCCard.count, npc_reward: NPCReward.count,
               locations: Location.count, quests: Quest.count  }

    # Find all of the Triple Triad NPC Residents and create the base NPC object
    puts '  Fetching resident data'
    npcs = CSV.new(open("#{BASE_URL}/csv/ENpcBase.csv")).drop(4).each_with_object({}) do |npc, h|
      npc[3..34].each do |data|
        if data&.match(/TripleTriad#(\d+)/) && h.values.find { |val| val[:id] == $1.to_i }.nil?
          h[npc[0]] = { id: $1.to_i, resident_id: npc[0].to_i }
          break
        end
      end
    end

    %w(en fr de ja).each do |locale|
      CSV.new(open("#{BASE_URL}/csv/ENpcResident.#{locale}.csv")).drop(4).each do |npc|
        if npcs.has_key?(npc[0])
          npcs[npc[0]]["name_#{locale}"] = sanitize_name(npc[1])
        end
      end
    end

    # Find the associated Level data for each NPC Resident and add the location data
    puts '  Fetching location coordinate data'
    CSV.new(open("#{BASE_URL}/csv/Level.raw.csv")).drop(4).each do |level|
      if npcs.has_key?(level[7])
        npcs[level[7]].merge!(x: level[1].to_f, y: level[3].to_f, map_id: level[8])
      end
    end

    map_ids = npcs.values.pluck(:map_id).uniq

    # Look up the relevant maps and set the coordinate data
    maps = CSV.new(open("#{BASE_URL}/csv/Map.raw.csv")).drop(4).each_with_object({}) do |map, h|
      if map_ids.include?(map[0])
        h[map[0]] = { region_id: map[10], location_id: map[11],
                      x_offset: map[8].to_f, y_offset: map[9].to_f, size_factor: map[7].to_f }
      end
    end

    npcs.values.each do |npc|
      map = maps[npc.delete(:map_id)]
      npc[:location_id] = map[:location_id].to_i
      npc[:x] = get_coordinate(npc[:x], map[:x_offset], map[:size_factor])
      npc[:y] = get_coordinate(npc[:y], map[:y_offset], map[:size_factor])
    end

    # Create the NPC locations
    puts '  Fetching location name data'
    locations = %w(en fr de ja).each_with_object(Hash.new({})) do |locale, h|
      places = CSV.new(open("#{BASE_URL}/csv/PlaceName.#{locale}.csv")).drop(3).map { |place| place[1] }
      maps.values.each do |map|
        h[map[:location_id]] = h[map[:location_id]].merge("name_#{locale}" => places[map[:location_id].to_i],
                                                          "region_#{locale}" => places[map[:region_id].to_i])
      end
    end

    locations.each do |id, data|
      Location.find_or_create_by!(data.merge(id: id))
    end

    # Add their opponent data
    puts '  Fetching opponent data'
    CSV.new(open("#{BASE_URL}/csv/TripleTriad.csv")).drop(5).each do |opponent|
      npc = npcs.values.find { |val| val[:id] == opponent[0].to_i }
      next unless npc.present?
      npc[:rewards] = Card.where(name_en: opponent[27..30].compact.map { |card| card.sub(/ Card$/, '') }).pluck(:id)
    end

    CSV.new(open("#{BASE_URL}/csv/TripleTriad.raw.csv")).drop(5).each do |opponent|
      npc = npcs.values.find { |val| val[:id] == opponent[0].to_i }
      next unless npc.present?
      npc[:quest_id] = opponent[16].to_i if opponent[16] != '0'
      npc[:fixed_cards] = opponent[1..5].reject { |card| card == '0' }
      npc[:variable_cards] = opponent[6..10].reject { |card| card == '0' }
      npc[:rules] = Rule.where(id: opponent[11..12].reject { |rule| rule == '0' })
    end

    # Create the pre-requisite quests
    puts '  Fetching quest data'
    quest_ids = npcs.values.pluck(:quest_id).uniq

    quests = %w(en de fr ja).each_with_object(Hash.new({})) do |locale, h|
      CSV.new(open("#{BASE_URL}/csv/Quest.#{locale}.csv")).drop(4).each do |quest|
        if quest_ids.include?(quest[0].to_i)
          name = sanitize_description(quest[1]).sub(/\A[^a-z0-9]/i, '').strip
          h[quest[0]] = h[quest[0]].merge("name_#{locale}" => name)
        end
      end
    end

    quests.each do |id, quest|
      unless Quest.exists?(id)
        Quest.create!(quest.merge(id: id))
      end
    end

    # Create the NPCs and their cards
    npcs.values.each do |data|
      fixed_cards = data.delete(:fixed_cards)
      variable_cards = data.delete(:variable_cards)
      rewards = data.delete(:rewards)

      # Create or update the NPC
      if npc = NPC.find_by(id: data[:id])
        data.except!('name_en', 'name_de', 'name_fr', 'name_ja', :rules)
        npc.update!(data) if updated?(npc, data)
      else
        npc = NPC.create!(data)
      end

      fixed_cards.each do |card|
        NPCCard.find_or_create_by!(npc_id: npc.id, card_id: card, fixed: true)
      end

      variable_cards.each do |card|
        NPCCard.find_or_create_by!(npc_id: npc.id, card_id: card, fixed: false)
      end

      rewards.each do |card|
        NPCReward.find_or_create_by!(npc_id: npc.id, card_id: card)
      end

      npc.update!(patch: npc.rewards.pluck(:patch).min) unless npc.patch.present?
    end

    counts.each do |klass, count|
      class_name = klass.to_s.classify
      puts "Created #{class_name.constantize.send(:count) - count} new #{class_name}s"
    end
  end
end

def get_coordinate(value, map_offset, size_factor)
  scale = size_factor / 100.0
  offset = (value + map_offset) * scale
  (((41.0 / scale) * ((offset + 1024.0) / 2048.0)) + 1).to_i
end

require 'csv'
require 'open-uri'

namespace :npcs do
  desc 'Create the NPCs'
  task create: :environment do
    puts 'Creating NPCs'
    counts = { npc: NPC.count, npc_card: NPCCard.count, npc_reward: NPCReward.count }

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
          name = npc[1]
          name = name.titleize if name =~ /^[a-z]/ # Fix lowercase names
          npcs[npc[0]]["name_#{locale}"] = name
        end
      end
    end

    # Find the associated Level data for each NPC Resident and add the location data
    puts '  Fetching location data'
    CSV.new(open("#{BASE_URL}/csv/Level.raw.csv")).drop(4).each do |level|
      if npcs.has_key?(level[7])
        npcs[level[7]].merge!(x: level[1].to_f, y: level[3].to_f, map_id: level[8])
      end
    end

    map_ids = npcs.values.pluck(:map_id)

    # Look up the relevant maps and set the NPC locations
    maps = CSV.new(open("#{BASE_URL}/csv/Map.csv")).drop(4).each_with_object({}) do |map, h|
      if map_ids.include?(map[0])
        h[map[0]] = { name: map[11], x_offset: map[8].to_f, y_offset: map[9].to_f, size_factor: map[7].to_f }
      end
    end

    npcs.values.each do |npc|
      map = maps[npc.delete(:map_id)]
      npc[:location] = map[:name]
      npc[:x] = get_coordinate(npc[:x], map[:x_offset], map[:size_factor])
      npc[:y] = get_coordinate(npc[:y], map[:y_offset], map[:size_factor])
    end

    # Add their opponent data
    puts '  Fetching opponent data'
    CSV.new(open("#{BASE_URL}/csv/TripleTriad.csv")).drop(5).each do |opponent|
      npc = npcs.values.find { |val| val[:id] == opponent[0].to_i }
      next unless npc.present?
      npc[:rules] = opponent[11..12].reject(&:empty?).join(', ')
      npc[:quest] = opponent[16].sub(/\A[^a-z0-9]/i, '')&.strip if opponent[16].present?
      npc[:rewards] = Card.where(name_en: opponent[27..30].compact.map { |card| card.sub(/ Card$/, '') }).pluck(:id)
    end

    CSV.new(open("#{BASE_URL}/csv/TripleTriad.raw.csv")).drop(5).each do |opponent|
      npc = npcs.values.find { |val| val[:id] == opponent[0].to_i }
      next unless npc.present?
      npc[:quest_id] = opponent[16].to_i if opponent[16] != '0'
      npc[:fixed_cards] = opponent[1..5].reject { |card| card == '0' }
      npc[:variable_cards] = opponent[6..10].reject { |card| card == '0' }
    end

    # Create the NPCs and their cards
    npcs.values.each do |data|
      fixed_cards = data.delete(:fixed_cards)
      variable_cards = data.delete(:variable_cards)
      rewards = data.delete(:rewards)

      # Create or update the NPC
      if npc = NPC.find_by(id: data[:id])
        data.except!('name_en', 'name_de', 'name_fr', 'name_ja')
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

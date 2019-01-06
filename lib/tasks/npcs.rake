require 'csv'
require 'open-uri'

namespace :npcs do
  MAP_COLUMNS = %w(ID PlaceName.Name OffsetX OffsetY SizeFactor).freeze

  desc 'Create the NPCs'
  task create: :environment do
    puts 'Creating NPCs'
    counts = { npc: NPC.count, npc_card: NPCCard.count, npc_reward: NPCReward.count }

    # Find all of the Triple Triad NPC Residents and create the base NPC object
    puts '  Fetching resident data'
    npcs = XIVAPI_CLIENT.search(indexes: 'enpcresident', columns: %w(ID Name TripleTriadID),
                                filters: 'TripleTriadID>0', limit: 200).each_with_object({}) do |npc, h|
      name = npc.name
      name = name.titleize if name =~ /^[a-z]/ # Fix lowercase names
      h[npc.triple_triad_id] = { id: npc.triple_triad_id, resident_id: npc.id, name: name }
    end

    resident_ids = npcs.values.pluck(:resident_id)

    # Find the associated Level data for each NPC Resident and add the location data
    puts '  Fetching location data'
    XIVAPI_CLIENT.content(name: 'Level', columns: %w(X Z Object Map.ID), limit: 1_000_000).each do |level|
      resident_id = level.object
      next unless resident_ids.include?(resident_id)
      data = { x: level.x.to_f, y: level.z.to_f, map_id: level.map.id }
      id, _ = npcs.find { |id, npc| npc[:resident_id] == resident_id }
      npcs[id].merge!(data)
    end

    map_ids = npcs.values.pluck(:map_id)

    # Look up the relevant maps and set the NPC locations
    maps = XIVAPI_CLIENT.content(name: 'Map', columns: MAP_COLUMNS, ids: map_ids).each_with_object({}) do |map, h|
      h[map.id] = { name: map.place_name.name, x_offset: map.offset_x, y_offset: map.offset_y, size_factor: map.size_factor }
    end

    npcs.each do |id, npc|
      map = maps[npc.delete(:map_id)]
      npcs[id][:location] = map[:name]
      npcs[id][:x] = get_coordinate(npc[:x], map[:x_offset], map[:size_factor])
      npcs[id][:y] = get_coordinate(npc[:y], map[:y_offset], map[:size_factor])
    end

    # Add their opponent data, then create them along with their decks and rewards
    puts '  Fetching opponent data'
    XIVAPI_CLIENT.content(name: 'TripleTriad', columns: '*', ids: npcs.keys).each do |data|
      rules = [data.triple_triad_rule0&.name, data.triple_triad_rule1&.name].compact.join(', ')
      quest_id = data.previous_quest0&.id
      # Remove invalid initial characters from quest names (e.g. beast tribe quests)
      quest_name = data.previous_quest0&.name&.sub(/\A[^a-z0-9]/i, '')&.strip

      npcs[data.id].merge!(rules: rules, quest_id: quest_id, quest: quest_name)
      npc_data = npcs[data.id]

      # Create or update the NPC
      if npc = NPC.find_by(id: data.id)
        npc_data.except!(:name)
        npc.update!(npc_data) if updated?(npc, npc_data)
      else
        npc = NPC.create!(npc_data)
      end

      # Create the NPC deck
      data.to_h.select { |k, v| k =~ /triple_triad_card_(fixed|variable)?\d_target_id/ && v != 0 }.each do |key, id|
        NPCCard.find_or_create_by!(npc_id: data.id, card_id: id, fixed: key.to_s.include?('fixed'))
      end

      # Create the NPC rewards
      data.to_h.select { |k, v| k =~ /item_possible_reward\d\Z/ && v != nil }.values.each do |reward|
        NPCReward.find_or_create_by!(npc_id: data.id, card_id: reward.additional_data)
      end

      npc.update!(patch: npc.rewards.pluck(:patch).min)
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

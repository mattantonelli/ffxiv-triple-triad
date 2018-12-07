require 'csv'
require 'open-uri'

namespace :npcs do
  NPC_DATA_URL = 'https://raw.githubusercontent.com/viion/ffxiv-datamining/master/csv/ENpcBase.csv'.freeze
  NPC_COLUMNS = %w(ID Name).freeze
  LEVEL_DATA_URL = 'https://raw.githubusercontent.com/viion/ffxiv-datamining/master/csv/Level.csv'.freeze
  MAP_COLUMNS = %w(ID PlaceName.Name OffsetX OffsetY SizeFactor).freeze

  desc 'Create the NPCs'
  task create: :environment do
    puts 'Creating NPCs'
    counts = { npc: NPC.count, npc_card: NPCCard.count, npc_reward: NPCReward.count }

    # Find all of the Triple Triad NPC IDs and create the base NPC object
    npcs = CSV.read(open(NPC_DATA_URL)).drop(3).each_with_object({}) do |npc, h|
      npc[3..34].each do |data|
        id = data.to_i
        break h[id] = { id: id, resident_id: npc[0].to_i } if id >> 16 == 35
      end
    end

    resident_ids = npcs.values.pluck(:resident_id)

    # Find the associated Level data for each NPC Resident and add the location data
    CSV.read(open(LEVEL_DATA_URL)).drop(3).each do |level|
      resident_id = level[-4].to_i
      next unless resident_ids.include?(resident_id)
      data = { x: level[1].to_f, y: level[3].to_f, map_id: level[-3].to_i }
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

    # Add the NPC name
    XIVAPI_CLIENT.content(name: 'ENpcResident', columns: NPC_COLUMNS, ids: npcs.values.pluck(:resident_id)).each do |data|
      id, _ = npcs.find { |id, npc| npc[:resident_id] == data[:id] }
      name = data.name
      name = name.titleize if name =~ /^[a-z]/ # Fix lowercase names
      npcs[id][:name] = name
    end

    # Add their opponent data, then create them along with their decks and rewards
    XIVAPI_CLIENT.content(name: 'TripleTriad', columns: '*', ids: npcs.keys).each do |data|
      npcs[data.id].merge!(rules: [data.triple_triad_rule0&.name, data.triple_triad_rule1&.name].compact.join(','),
                           quest: data.previous_quest0&.name)

      npc = NPC.find_or_create_by!(npcs[data.id])

      # Create the NPC deck
      data.to_h.select { |k, v| k =~ /triple_triad_card_(fixed|variable)?\d_target_id/ && v != 0 }.each do |key, id|
        NPCCard.find_or_create_by!(npc_id: data.id, card_id: id, fixed: key.to_s.include?('fixed'))
      end

      # Create the NPC rewards
      data.to_h.select { |k, v| k =~ /item_possible_reward\d\Z/ && v != nil }.values.each do |reward|
        NPCReward.find_or_create_by!(npc_id: data.id, card_id: reward.additional_data)
      end
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

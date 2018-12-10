namespace :cards do
  CARD_COLUMNS = %w(ID Name Description).freeze
  RESIDENT_COLUMNS = %w(ID Top Right Bottom Left SortKey TripleTriadCardRarity.Stars TripleTriadCardTypeTargetID).freeze
  ITEM_COLUMNS = %w(AdditionalData GamePatch.Version).freeze

  desc 'Create the cards'
  task create: :environment do
    puts 'Creating cards'
    count = Card.count

    # Load the base cards
    cards = XIVAPI_CLIENT.content(name: 'TripleTriadCard', columns: CARD_COLUMNS, limit: 1000)
      .each_with_object({}) do |card, h|
      name = card.name
      name = name.titleize if name =~ /^[a-z]/ # Fix lowercase names
      h[card.id] = { id: card.id, name: name, description: card.description }
    end

    # Add their various stats
    XIVAPI_CLIENT.content(name: 'TripleTriadCardResident', columns: RESIDENT_COLUMNS, limit: 1000).each do |stats|
      cards[stats.id].merge!(top: stats.top, right: stats.right, bottom: stats.bottom, left: stats.left,
                             sort_id: stats.sort_key, stars: stats.triple_triad_card_rarity.stars.to_i,
                             card_type_id: stats.triple_triad_card_type_target_id)
    end

    # And their patch numbers
    XIVAPI_CLIENT.search(indexes: 'Item', filters: 'ItemUICategoryTargetID=86', columns: ITEM_COLUMNS, limit: 1000).each do |item|
      cards[item.additional_data][:patch] = item.game_patch.version
    end

    # Then set their sale prices and create them
    cards.each do |id, data|
      data[:sell_price] = case(data[:stars])
                          when 1 then 100
                          when 2 then 300
                          when 3 then 500
                          when 4 then 800
                          when 5 then 1500
                          end

      # Find or create the card
      card = Card.find_or_create_by!(data.except(:sort_id))

      # Then set the sort ID (which has probably changed between patches)
      card.update!(sort_id: data[:sort_id])
    end

    puts "Created #{Card.count - count} new cards"
  end
end

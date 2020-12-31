require 'xiv_data'

namespace :cards do
  desc 'Create the cards'
  task create: :environment do
    puts 'Creating cards'
    count = Card.count

    # Load the base cards
    cards = XIVData.sheet('TripleTriadCard', locale: 'en').each_with_object({}) do |card, h|
      h[card['#']] = { id: card['#'].to_i, name_en: sanitize_name(card['Name']),
                       description_en: sanitize_description(card['Description']) }
    end

    %w(fr de ja).each do |locale|
      XIVData.sheet('TripleTriadCard', locale: locale).each do |card|
        cards[card['#']].merge!("name_#{locale}" => sanitize_name(card['Name']),
                                "description_#{locale}" => sanitize_description(card['Description']))
      end
    end

    # Add their various stats
    XIVData.sheet('TripleTriadCardResident').each do |card|
      stars = card['TripleTriadCardRarity'].scan(/\d$/).first.to_i
      type_id = CardType.find_by(name_en: card['TripleTriadCardType'])&.id || 0
      cards[card['#']].merge!(top: card['Top'].to_i, bottom: card['Bottom'].to_i,
                              left: card['Left'].to_i, right: card['Right'].to_i,
                              stars: stars, card_type_id: type_id.to_i, sell_price: card['SaleValue'].to_i,
                              deck_order: card['SortKey'].to_i, order_group: card['UIPriority'].to_i, order: card['Order'].to_i)
    end

    # Then create or update them
    cards.each do |id, data|
      if card = Card.find_by(id: data[:id])
        card.update!(data) if updated?(card, data.symbolize_keys)
      else
        card = Card.create!(data) if data[:name_en].present?
      end
    end

    puts "Created #{Card.count - count} new cards"
  end

  desc 'Create card sources from in-game Acquisition details'
  task create_sources: :environment do
    XIVData.sheet('TripleTriadCardResident').each do |card|
      type = card['AcquisitionType'].to_i
      acquisition = card['Acquisition']

      case type
      when 2, 3
        origin = Instance.find_by(name_en: acquisition).duty_type
      # when 4, 5
      #   origin = 'FATE'
      #   acquisition = "FATE: #{acquisition}"
      when 8, 9
        next unless acquisition =~ /Triad Card/
        pack = Pack.find_by(name_en: acquisition)
        PackCard.find_or_create_by!(pack_id: pack.id, card_id: card['#'])
      end

      if origin.present?
        card = Card.find(card['#'])
        card.sources.find_or_create_by!(name: acquisition, origin: origin)
      end
    end
  end
end

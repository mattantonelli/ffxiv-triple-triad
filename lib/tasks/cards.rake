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

  desc 'Create card sources from in-game Acquisition details and shops'
  task create_sources: :environment do
    puts 'Creating card Acqusition sources'
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

    puts 'Creating SpecialShop sources'
    XIVData.sheet('SpecialShop', locale: 'en').each do |shop|
      60.times do |i|
        item = shop["Item{Receive}[#{i}][0]"]
        break if item.nil?
        next unless item.match?(/ Card$/) && card = Card.where('BINARY name_en like ?', "%#{item.sub(/ Card$/, '')}%").first

        price = shop["Count{Cost}[#{i}][0]"]
        next if price == '0'

        currency = shop["Item{Cost}[#{i}][0]"]

        if currency == 'MGP'
          card.update!(buy_price: price) unless card.buy_price.present?
        elsif card.sources.none?
          card.sources.create!(origin: 'Other', name: "#{price} #{currency.pluralize}")
        end
      end
    end
  end
end

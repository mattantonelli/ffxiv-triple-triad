require 'csv'
require 'open-uri'

namespace :cards do
  desc 'Create the cards'
  task create: :environment do
    puts 'Creating cards'
    count = Card.count

    # Load the base cards
    cards = CSV.new(open("#{BASE_URL}/csv/TripleTriadCard.en.csv")).drop(4).each_with_object({}) do |card, h|
      name = card[1]
      name = name.titleize if name =~ /^[a-z]/ # Fix lowercase names
      description = card[9].gsub(/\<.*?\>/, '').gsub("\r", "\n")
      h[card[0]] = { id: card[0].to_i, name_en: name, description_en: description }
    end

    %w(fr de ja).each do |locale|
      CSV.new(open("#{BASE_URL}/csv/TripleTriadCard.#{locale}.csv")).drop(4).each do |card|
        name = card[1]
        name = name.titleize if name =~ /^[a-z]/ # Fix lowercase names
        description = card[9].gsub('<SoftHyphen/>', "\u00AD")
          .gsub(/<Switch.*?><Case\(1\)>(.*?)<\/Case>.*?<\/Switch>/, '\1')
          .gsub(/<If.*?>(.*?)<Else\/>.*?<\/If>/, '\1')
          .gsub(/\<.*?\>/, '')
          .gsub("\r", "\n")
        cards[card[0]].merge!("name_#{locale}" => name, "description_#{locale}" => description)
      end
    end

    # Add their various stats
    CSV.new(open("#{BASE_URL}/csv/TripleTriadCardResident.csv")).drop(4).each do |card|
      stars = card[6].scan(/\d$/).first
      type_id = CardType.find_by(name: card[7])&.id || 0
      cards[card[0]].merge!(top: card[2].to_i, bottom: card[3].to_i, left: card[4].to_i, right: card[5].to_i,
                            stars: stars.to_i, card_type_id: type_id.to_i, sell_price: card[8].to_i, sort_id: card[9].to_i)
    end

    # Then create or update them
    cards.each do |id, data|
      if card = Card.find_by(id: data[:id])
        card.update!(data) if updated?(card, data.except(:sort_id))
      else
        card = Card.create!(data) if data[:name_en].present?
      end
    end

    puts "Created #{Card.count - count} new cards"
  end
end

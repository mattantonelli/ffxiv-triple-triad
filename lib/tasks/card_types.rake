require 'csv'
require 'open-uri'

namespace :card_types do
  desc 'Create the card types'
  task create: :environment do
    puts 'Creating card types'
    count = CardType.count

    # Typeless cards reference ID 0, so create it
    CardType.find_or_create_by!(id: 0, name_en: 'Normal', name_de: 'Normal', name_fr: 'Normal', name_ja: 'ノーマル')

    types = %w(en de fr ja).map do |locale|
      CSV.new(open("#{BASE_URL}/csv/TripleTriadCardType.#{locale}.csv")).drop(4).map do |type|
        type[1] unless type[1].blank?
      end
    end

    types.map(&:compact!).transpose.each_with_index do |type, i|
      CardType.create!(id: i + 1, name_en: type[0], name_de: type[1], name_fr: type[2], name_ja: type[3])
    end

    puts "Created #{CardType.count - count} new card types"
  end
end

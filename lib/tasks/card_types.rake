require 'csv'
require 'open-uri'

namespace :card_types do
  desc 'Create the card types'
  task create: :environment do
    puts 'Creating card types'
    count = CardType.count

    # Typeless cards reference ID 0, so create it
    CardType.find_or_create_by!(id: 0, name: 'Normal')

    CSV.new(open("#{BASE_URL}/csv/TripleTriadCardType.en.csv")).drop(4).each do |type|
      puts type
      CardType.find_or_create_by!(id: type[0], name: type[1]) unless type[1].blank?
    end

    puts "Created #{CardType.count - count} new card types"
  end
end

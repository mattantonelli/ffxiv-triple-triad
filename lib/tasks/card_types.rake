namespace :card_types do
  desc 'Create the card types'
  task create: :environment do
    puts 'Creating card types'
    count = CardType.count

    XIVAPI_CLIENT.content(name: 'TripleTriadCardType', columns: %w(ID Name)).each do |type|
      CardType.find_or_create_by!(id: type.id, name: type.name)
    end

    puts "Created #{CardType.count - count} new card types"
  end
end

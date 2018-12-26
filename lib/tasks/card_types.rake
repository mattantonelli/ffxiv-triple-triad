namespace :card_types do
  desc 'Create the card types'
  task create: :environment do
    puts 'Creating card types'
    count = CardType.count

    # Typeless cards reference ID 0, so create it
    CardType.find_or_create_by!(id: 0, name: 'Normal')

    XIVAPI_CLIENT.content(name: 'TripleTriadCardType', columns: %w(ID Name)).each do |type|
      CardType.find_or_create_by!(id: type.id, name: type.name) unless type.name.blank?
    end

    puts "Created #{CardType.count - count} new card types"
  end
end

require 'xiv_data'

namespace :quests do
  desc 'Create the quests'
  task create: :environment do
    puts 'Creating quests'
    count = Quest.count

    quests = %w(en de fr ja).each_with_object({}) do |locale, h|
      XIVData.sheet('Quest', locale: locale).each do |quest|
        next unless quest['Name'].present?

        data = h[quest['#']] || { id: quest['#'].to_i }

        # Format and strip any garbage characters
        data["name_#{locale}"] = sanitize_description(quest['Name']).gsub(/\uE0BE ?/, '').strip

        h[quest['#']] = data
      end
    end

    quests.each do |id, data|
      if quest = Quest.find_by(id: data[:id])
        quest.update!(data) if updated?(quest, data)
      else
        Quest.create!(data)
      end
    end

    puts "Created #{Quest.count - count} new quests"
  end
end

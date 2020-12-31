require 'xiv_data'

namespace :achievements do
  TRIAD_ACHIEVEMENT_NAMES = /(Kumite|Triple-Decker|Triple Team|Wheel of Fortune|Open and Shut|Open to Victory)/i.freeze

  desc 'Create the achievements'
  task create: :environment do
    puts 'Creating achievements'
    count = Achievement.count

    # Load the base achievements
    achievements = XIVData.sheet('Achievement', locale: 'en').each_with_object({}) do |achievement, h|
      # Only create achievements matching known TT achievement names and having rewards
      next unless achievement['Name'].match?(TRIAD_ACHIEVEMENT_NAMES) && achievement['Item'].present?

      if card = Card.find_by(name_en: achievement['Item'].gsub(' Card', ''))
        h[achievement['#']] = { id: achievement['#'].to_i, name_en: sanitize_name(achievement['Name']),
                              description_en: achievement['Description'], card_id: card.id }
      end
    end

    # Add their localized data
    %w(fr de ja).each do |locale|
      XIVData.sheet('Achievement', locale: locale).each do |achievement|
        next unless achievements.keys.include?(achievement['#'])
        achievements[achievement['#']].merge!("name_#{locale}" => sanitize_name(achievement['Name']),
                                            "description_#{locale}" => achievement['Description'])
      end
    end

    # Then create or update them
    achievements.each do |id, data|
      if achievement = Achievement.find_by(id: data[:id])
        achievement.update!(data) if updated?(achievement, data.symbolize_keys)
      else
        achievement = Achievement.create!(data) if data[:name_en].present?
      end
    end

    puts "Created #{Achievement.count - count} new achievements"
  end
end

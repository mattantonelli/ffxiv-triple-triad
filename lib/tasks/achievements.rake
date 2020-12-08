require 'csv'
require 'open-uri'

namespace :achievements do
  TRIAD_ACHIEVEMENT_NAMES = /(Kumite|Triple-Decker|Triple Team|Wheel of Fortune|Open and Shut|Open to Victory)/i.freeze

  desc 'Create the achievements'
  task create: :environment do
    puts 'Creating achievements'
    count = Achievement.count

    # Load the base achievements
    achievements = CSV.new(open("#{BASE_URL}/csv/Achievement.en.csv")).drop(4).each_with_object({}) do |achievement, h|
      # Only create achievements matching known TT achievement names and having rewards
      next unless achievement[2].match?(TRIAD_ACHIEVEMENT_NAMES) && achievement[6].present?

      if card = Card.find_by(name_en: achievement[6].gsub(' Card', ''))
        h[achievement[0]] = { id: achievement[0].to_i, name_en: sanitize_name(achievement[2]),
                              description_en: achievement[3], card_id: card.id }
      end
    end

    # Add their localized data
    %w(fr de ja).each do |locale|
      CSV.new(open("#{BASE_URL}/csv/Achievement.#{locale}.csv")).drop(4).each do |achievement|
        next unless achievements.keys.include?(achievement[0])
        achievements[achievement[0]].merge!("name_#{locale}" => sanitize_name(achievement[2]),
                                            "description_#{locale}" => achievement[3])
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

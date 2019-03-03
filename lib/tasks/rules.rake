require 'csv'
require 'open-uri'

namespace :rules do
  desc 'Create the rules'
  task create: :environment do
    puts 'Creating rules'
    count = Rule.count

    rules = %w(en de fr ja).map do |locale|
      CSV.new(open("#{BASE_URL}/csv/TripleTriadRule.#{locale}.csv")).drop(4).flat_map do |rule|
        rule[1..2]
      end
    end

    rules.transpose.each_slice(2).each_with_index do |rule, i|
      rule.flatten!
      Rule.create!(id: i + 1, name_en: rule[0], name_de: rule[1], name_fr: rule[2], name_ja: rule[3],
                   description_en: rule[4], description_de: rule[5], description_fr: rule[6], description_ja: rule[7])
    end

    puts "Created #{Rule.count - count} new rules"
  end
end

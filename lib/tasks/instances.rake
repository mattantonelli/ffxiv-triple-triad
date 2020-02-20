require 'csv'
require 'open-uri'

namespace :instances do
  desc 'Create translation files for instances'
  task translate: :environment do
    puts 'Creating instance translations'

    names = CSV.new(open("#{BASE_URL}/csv/ContentFinderCondition.en.csv")).drop(3).each_with_object({}) do |instance, h|
      name = instance[36]
      next unless name.present?
      h[instance[0]] = sanitize_instance_name(name).delete('.')
    end

    %w(de fr ja).map do |locale|
      instances = CSV.new(open("#{BASE_URL}/csv/ContentFinderCondition.#{locale}.csv")).drop(3).each_with_object({}) do |instance, h|
        name = instance[36]
        next unless name.present?
        h[names[instance[0]]] = sanitize_instance_name(name)
      end

      File.open(Rails.root.join("config/locales/instances/#{locale}.yml"), 'w') do |file|
        file.puts({ locale => instances }.to_yaml)
      end
    end
  end

  def sanitize_instance_name(name)
    name[0] = name[0].upcase
    sanitize_description(name).delete('*')
  end
end

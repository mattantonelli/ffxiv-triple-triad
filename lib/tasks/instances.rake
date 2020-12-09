require 'csv'
require 'open-uri'

namespace :instances do
  VALID_TYPES = %w(Dungeons Trials Raids).freeze

  desc 'Create instances and their translations'
  task create: :environment do
    puts 'Creating instances and their translations'
    count = Instance.count

    instances = CSV.new(open("#{BASE_URL}/csv/ContentFinderCondition.en.csv")).drop(3).each_with_object({}) do |instance, h|
      id, name, type = instance.values_at(0, 38, 39)

      if name.present? and VALID_TYPES.include?(type)
        h[id] = { id: id, name_en: sanitize_instance_name(name), duty_type: type.singularize }
      end
    end

    %w(de fr ja).map do |locale|
      key = "name_#{locale}".to_sym

      CSV.new(open("#{BASE_URL}/csv/ContentFinderCondition.#{locale}.csv")).drop(3).each_with_object({}) do |instance, h|
        id, name = instance.values_at(0, 38)

        if instances.has_key?(id)
          instances[id][key] = sanitize_instance_name(name)
        end
      end

      # Create I18n translations for English names in the sources
      File.open(Rails.root.join("config/locales/instances/#{locale}.yml"), 'w') do |file|
        translations = instances.values.map { |t| [t[:name_en].delete('.*'), t[key]] }.to_h
        file.puts({ locale => translations }.to_yaml)
      end
    end

    instances.each do |id, data|
      if instance = Instance.find_by(id: id)
        instance.update!(data) if updated?(instance, data)
      else
        Instance.create!(data)
      end
    end

    puts "Created #{Instance.count - count} new instances"
  end

  def sanitize_instance_name(name)
    name[0] = name[0].upcase
    sanitize_description(name)
  end
end

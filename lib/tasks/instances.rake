require 'xiv_data'

namespace :instances do
  VALID_TYPES = %w(Dungeons Trials Raids).freeze

  desc 'Create instances and their translations'
  task create: :environment do
    puts 'Creating instances and their translations'
    count = Instance.count

    instances = XIVData.sheet('ContentFinderCondition', locale: 'en').each_with_object({}) do |instance, h|
      id, name, type = instance.values_at('#', 'Name', 'ContentType')

      if name.present? and VALID_TYPES.include?(type)
        h[id] = { id: id.to_i, name_en: sanitize_instance_name(name), duty_type: type.singularize }
      end
    end

    %w(de fr ja).each do |locale|
      key = "name_#{locale}".to_sym

      XIVData.sheet('ContentFinderCondition', locale: locale).each_with_object({}) do |instance, h|
        id = instance['#']
        name = instance['Name']

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

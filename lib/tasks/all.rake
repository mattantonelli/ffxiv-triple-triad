BASE_URL = 'https://raw.githubusercontent.com/mattantonelli/ffxiv-triple-triad-data/master'.freeze

namespace :data do
  desc 'Initialize all Triple Triad data'
  task initialize: :environment do
    puts 'Loading all Triple Triad data'
    Rake::Task['card_types:create'].invoke
    Rake::Task['cards:create'].invoke
    Rake::Task['patch:set'].invoke
    Rake::Task['npcs:create'].invoke
    Rake::Task['card_images:download'].invoke
    Rake::Task['card_sources:set'].invoke
    Rake::Task['card_packs:create'].invoke
  end

  desc 'Updates all Triple Triad data'
  task update: :environment do
    puts 'Loading all Triple Triad data'
    Rake::Task['cards:create'].invoke
    Rake::Task['npcs:create'].invoke
    Rake::Task['card_images:download'].invoke
  end
end

# Replace various tags with the appropriate text
def sanitize_description(description)
  description.gsub('<SoftHyphen/>', "\u00AD")
    .gsub(/<Switch.*?><Case\(1\)>(.*?)<\/Case>.*?<\/Switch>/, '\1')
    .gsub(/<If.*?>(.*?)<Else\/>.*?<\/If>/, '\1')
    .gsub(/<\/?Emphasis>/, '*')
    .gsub('<Indent/>', ' ')
    .gsub(/\<.*?\>/, '')
    .gsub("\r", "\n")
end

# Fix lowercase names and German gender tags
def sanitize_name(name)
  name = name.titleize if name =~ /^[a-z]/
  name.gsub('[t]', 'der')
    .gsub('[a]', 'e')
    .gsub('[A]', 'er')
    .gsub('[p]', '')
end

def updated?(model, data)
  current = model.attributes.symbolize_keys.select { |k, _| data.keys.include?(k) }

  if updated = data != current
    puts "  Found new data for #{model.id}:"
    diff = data.map do |k, v|
      "#{k}: #{current[k]} → #{v}" if current[k] != v
    end
    puts "    #{diff.compact.join(', ')}"
  end

  updated
end

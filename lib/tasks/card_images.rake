require 'open-uri'

namespace :card_images do
  desc 'Download the images for each card'
  task download: :environment do
    puts 'Downloading card images'

    LARGE_DIR = Rails.root.join('app', 'assets', 'images', 'cards', 'large')
    SMALL_DIR = Rails.root.join('app', 'assets', 'images', 'cards', 'small')
    counts = { large: Dir.entries(LARGE_DIR).size, small: Dir.entries(SMALL_DIR).size }

    Card.pluck(:id).each do |id|
      unless LARGE_DIR.join("#{id}.png").exist?
        download_image(LARGE_DIR, 82100, id)
      end

      unless SMALL_DIR.join("#{id}.png").exist?
        download_image(SMALL_DIR, 82500, id)
      end
    end

    puts "Downloaded #{Dir.entries(LARGE_DIR).size - counts[:large]} large images"
    puts "Downloaded #{Dir.entries(SMALL_DIR).size - counts[:small]} small images"
  end
end

def download_image(dir, offset, id)
  open(dir.join("#{id}.png").to_s, 'wb') do |file|
    file << open("https://xivapi.com/i/082000/0#{offset + id}.png").read
  end
end

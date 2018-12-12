require 'open-uri'

namespace :card_images do
  LARGE_DIR = Rails.root.join('app/assets/images/cards/large')
  SMALL_DIR = Rails.root.join('app/assets/images/cards/small')
  BACKGROUND = ChunkyPNG::Image.from_file(Rails.root.join('app/assets/images/cards/background.png'))
  STAR = ChunkyPNG::Image.from_file(Rails.root.join('app/assets/images/cards/star.png'))
  TYPES = (1..4).map { |id| ChunkyPNG::Image.from_file(Rails.root.join("app/assets/images/cards/types/#{id}.png")) }

  desc 'Download the images for each card'
  task download: :environment do
    puts 'Downloading card images'

    counts = { large: Dir.entries(LARGE_DIR).size, small: Dir.entries(SMALL_DIR).size }

    Card.all.each do |card|
      unless LARGE_DIR.join("#{card.id}.png").exist?
        download_large(card)
      end

      unless SMALL_DIR.join("#{card.id}.png").exist?
        download_small(card)
      end
    end

    puts "Downloaded #{Dir.entries(LARGE_DIR).size - counts[:large]} large images"
    puts "Downloaded #{Dir.entries(SMALL_DIR).size - counts[:small]} small images"
  end
end

def download_large(card)
  image = ChunkyPNG::Image.from_stream(download_image(82100, card.id))
  image = BACKGROUND.compose(image)

  if card.card_type_id > 0
    image.compose!(TYPES[card.card_type_id - 1], 80, 3)
  end

  card.stars.times do |stars|
    case(stars + 1)
    when 1 then image.compose!(STAR, 18, 6)
    when 2 then image.compose!(STAR, 9, 12)
    when 3 then image.compose!(STAR, 26, 12)
    when 4 then image.compose!(STAR, 13, 21)
    when 5 then image.compose!(STAR, 23, 21)
    end
  end

  image.save(LARGE_DIR.join("#{card.id}.png").to_s)
end

def download_small(card)
  open(SMALL_DIR.join("#{card.id}.png").to_s, 'wb') do |file|
    file << download_image(82500, card.id).read
  end
end

def download_image(offset, id)
  open("https://xivapi.com/i/082000/0#{offset + id}.png")
end

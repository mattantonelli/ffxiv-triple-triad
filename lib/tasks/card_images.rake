require 'xiv_data'

namespace :card_images do
  LARGE_DIR = Rails.root.join('public/images/cards/large').freeze
  SMALL_DIR = Rails.root.join('public/images/cards/small').freeze
  IMAGES_DIR = Rails.root.join('app/assets/images/cards').freeze
  BACKGROUND = ChunkyPNG::Image.from_file(IMAGES_DIR.join('background.png')).freeze
  STAR = ChunkyPNG::Image.from_file(IMAGES_DIR.join('star.png')).freeze
  LARGE_OFFSET = 82100.freeze
  SMALL_OFFSET = 82500.freeze

  type_sheet = ChunkyPNG::Image.from_file(IMAGES_DIR.join('types.png'))
  TYPES = (1..4).map { |id| type_sheet.crop(20 * (id - 1), 0, 20, 20) }.freeze

  number_sheet = ChunkyPNG::Image.from_file(IMAGES_DIR.join('numbers.png'))
  NUMBERS = (1..10).map { |num| number_sheet.crop(15 * (num - 1), 0, 15, 15) }.freeze

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

    create_sheet(SMALL_DIR, IMAGES_DIR.join('small.png'), 40, 40)
    create_sheet(LARGE_DIR, IMAGES_DIR.join('large.png'), 104, 128)

    puts 'Created spritesheets for the latest card images'
  end
end

def download_large(card)
  image = ChunkyPNG::Image.from_stream(XIVData.image(LARGE_OFFSET + card.id))
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

  image.compose!(NUMBERS[card.top - 1], 45, 89)
  image.compose!(NUMBERS[card.right - 1], 59, 96)
  image.compose!(NUMBERS[card.bottom - 1], 45, 103)
  image.compose!(NUMBERS[card.left - 1], 31, 96)

  image.save(LARGE_DIR.join("#{card.id}.png").to_s)
end

def download_small(card)
  open(SMALL_DIR.join("#{card.id}.png").to_s, 'wb') do |file|
    file << XIVData.image(SMALL_OFFSET + card.id).read
  end
end

def create_sheet(source, destination, width, height)
  ids = Card.order(:id).pluck(:id)
  sheet = ChunkyPNG::Image.new(width * Card.pluck(:id).max, height)

  ids.each do |id|
    image = source.join("#{id}.png")
    sheet.compose!(ChunkyPNG::Image.from_file(image), width * (id - 1), 0)
  end

  sheet.save(destination.to_s)
end

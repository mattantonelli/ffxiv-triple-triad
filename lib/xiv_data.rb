require 'csv'
require 'open-uri'

module XIVData
  extend self

  BASE_URL = 'https://raw.githubusercontent.com/mattantonelli/xiv-data/master'.freeze

  def sheet(sheet, locale: nil, raw: false, drop_zero: true)
    if raw
      url = "#{BASE_URL}/rawexd/#{sheet}.csv"
    elsif locale.present?
      url = "#{BASE_URL}/exd-all/#{sheet}.#{locale}.csv"
    else
      url = "#{BASE_URL}/exd-all/#{sheet}.csv"
    end

    data = open(url) { |f| f.readlines }
    headers = data[1].chomp
    CSV.new(data.drop(drop_zero ? 4 : 3).join, headers: headers.split(','))
  end

  def image(id)
    number = id.to_s.rjust(6, '0')
    directory = number.first(3).ljust(6, '0')
    url = "#{BASE_URL}/ui/icon/#{directory}/#{number}.png"
    open(url)
  end
end

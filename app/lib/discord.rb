include ActionView::Helpers::DateHelper
include ActionView::Helpers::NumberHelper

module Discord
  ROOT_URL = 'https://triad.raelys.com'.freeze
  EMBED_COLOR = 0xcaa665.freeze

  extend self

  def embed_card(name: nil, number: nil)
    if number.present?
      url = "#{ROOT_URL}/api/cards?order_eq=#{number}"
      results = JSON.parse(RestClient.get(url), symbolize_names: true)[:results]
    else
      results = search_by_name('cards', name)
    end

    card = results.first

    if card.nil?
      return { content: 'Card not found' }
    end

    embed = Discordrb::Webhooks::Embed.new(color: EMBED_COLOR)

    embed.image = Discordrb::Webhooks::EmbedImage.new(url: card[:image])
    embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: card[:icon])
    embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: "#{card[:name]} (No. #{card[:order]})",
                                                        url: "#{ROOT_URL}/cards/#{card[:id]}")

    embed.add_field(name: 'Rarity', value: "\u2605" * card[:stars], inline: true)
    embed.add_field(name: 'Owned', value: card[:owned], inline: true)
    embed.add_field(name: 'Patch', value: card[:patch], inline: true)

    sources = card[:sources]
    if sources.present?
      sources[:purchase] = "#{sources[:purchase]} MGP" if sources[:purchase].present?
      embed.add_field(name: 'Source', value: sources.values.flatten.join("\n"))
    end

    embed.add_field(name: 'Description', value: card[:description])

    if results.size > 1
      embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: additional_results(results))
    end

    { embeds: [embed.to_hash] }
  end

  def embed_npc(query)
    results = search_by_name('npcs', name)
    npc = results.first

    if npc.nil?
      return { content: 'NPC not found' }
    end

    embed = Discordrb::Webhooks::Embed.new(color: EMBED_COLOR)

    # TODO

    if results.size > 1
      embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: additional_results(results))
    end

    { embeds: [embed.to_hash] }
  end

  def embed_pack(query)
    results = search_by_name('packs', name)
    pack = results.first

    if pack.nil?
      return { content: 'Pack not found' }
    end

    embed = Discordrb::Webhooks::Embed.new(color: EMBED_COLOR)

    # TODO

    { embeds: [embed.to_hash] }
  end

  def embed_user(profile)
    url = "#{ROOT_URL}/api/users/#{profile[:id]}"
    user = JSON.parse(RestClient.get(url), symbolize_names: true)

    embed = Discordrb::Webhooks::Embed.new(color: 0xcaa665)

    embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: profile[:avatar])
    embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: "#{profile[:username]}",
                                                        url: "#{ROOT_URL}/users/#{profile[:id]}")

    cards = user[:cards]
    embed.add_field(name: "Cards#{star(cards[:owned], cards[:total])}",
                    value: "#{cards[:owned]} / #{cards[:total]} (#{cards[:completion]})")

    npcs = user[:npcs]
    embed.add_field(name: "NPCs#{star(cards[:owned], cards[:total])}",
                    value: "#{npcs[:defeated]} / #{npcs[:total]} (#{npcs[:completion]})")

    { embeds: [embed.to_hash] }
  end

  private
  def search_by_name(endpoint, name)
    url = "#{ROOT_URL}/api/#{endpoint}?name_en_eq=#{name}"
    JSON.parse(RestClient.get(url), symbolize_names: true)[:results].sort_by { |result| result[:name].size }
  end

  def additional_results(results)
    names = results[1..10].map { |result| result[:name] }
    names << '...' if results.size > 11
    "Also available: #{names.join(', ')}"
  end

  def star(count, total)
    " \u2605" if count == total
  end
end

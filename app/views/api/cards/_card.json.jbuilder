json.(card, :id, :sort_id, :name, :description, :stars, :patch, :sell_price)
json.icon image_url("cards/small/#{card.id}.png", skip_pipeline: true)
json.image image_url("cards/large/#{card.id}.png", skip_pipeline: true)

json.stats do
  json.numeric do
    json.(card, :top, :right, :bottom, :left)
  end

  json.formatted do
    %i(top right bottom left).each do |side|
      json.set! side, card.send(side).to_s.sub(/10/, 'A')
    end
  end
end

json.type do
  json.id card.type.id
  json.name card.type.name
  json.image card.type.id > 0 ? image_url("cards/types/#{card.type.id}.png", skip_pipeline: true) : nil
end

json.owned card.ownership

unless local_assigns[:skip_sources]
  json.sources do
    json.npcs do
      json.partial! '/api/npcs/npc', collection: card.npc_sources, as: :npc
    end

    json.pack do
      if card.pack
        json.partial! '/api/packs/pack', pack: card.pack, skip_cards: true
      else
        json.merge! nil
      end
    end

    drops = card.sources.map do |source|
      origin = "#{source.origin}: " unless %w(Other Eureka FATE Tournament).include?(source.origin)
      name = I18n.t(source.name.delete('.*'), default: source.name)
      "#{origin}#{name}"
    end

    json.drops drops
    json.purchase card.buy_price || nil
  end
end

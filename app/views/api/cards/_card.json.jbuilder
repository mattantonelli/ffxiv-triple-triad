json.(card, :id, :sort_id, :name, :description, :stars, :patch, :sell_price)
json.icon image_url("cards/small/#{card.id}.png", skip_pipeline: true)
json.image image_url("cards/large/#{card.id}.png", skip_pipeline: true)

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

    json.drops card.sources.pluck(:name).map { |name| I18n.t(name.delete('.*'), default: name) }
    json.purchase card.buy_price || 0
  end
end

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

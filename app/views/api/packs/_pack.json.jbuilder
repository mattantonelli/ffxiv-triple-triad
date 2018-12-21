json.(pack, :id, :name, :cost)

unless local_assigns[:skip_cards]
  json.cards do
    json.partial! '/api/cards/card', collection: pack.cards.sort_by(&:id), as: :card, skip_sources: true
  end
end

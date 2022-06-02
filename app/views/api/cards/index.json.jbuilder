json.query @query_params
json.count @cards.count
json.results do
  json.cache! [@cards, I18n.locale] do
    json.partial! 'card', collection: @cards, as: :card, ownership: @ownership
  end
end

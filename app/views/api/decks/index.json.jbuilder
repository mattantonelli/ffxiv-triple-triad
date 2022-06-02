json.query @query_params
json.count @decks.size
json.results do
  json.cache! [@decks, I18n.locale] do
    json.partial! 'deck', collection: @decks, as: :deck
  end
end

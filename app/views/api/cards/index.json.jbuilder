json.query @query_params
json.count @cards.count
json.results do
  json.partial! 'card', collection: @cards, as: :card, show_owned: @cards.count == 1
end

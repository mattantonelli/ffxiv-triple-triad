json.query @query_params
json.count @npcs.count
json.results do
  json.cache! [@npcs, @include_deck, I18n.locale] do
    json.partial! 'npc', collection: @npcs, as: :npc, include_deck: @include_deck, include_rewards: true
  end
end

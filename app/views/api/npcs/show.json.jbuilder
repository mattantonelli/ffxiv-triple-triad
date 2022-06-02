json.cache! [@npc, I18n.locale] do
  json.partial! 'npc', npc: @npc, include_deck: @include_deck, include_rewards: true
end

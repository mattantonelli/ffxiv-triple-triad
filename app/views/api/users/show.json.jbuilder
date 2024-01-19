json.cards do
  json.owned @user_cards.size
  json.missing @total_cards - @user_cards.size
  json.total @total_cards
  json.completion "#{@card_completion.to_i}%"
  json.ids @user_cards.sort

  json.random_missing do
    json.partial! '/api/cards/card', collection: @random_cards, as: :card
  end
end

json.npcs do
  json.defeated @defeated_npcs
  json.undefeated @total_npcs - @defeated_npcs
  json.total @total_npcs
  json.completion "#{@npc_completion.to_i}%"
  json.ids @user_npcs.pluck(:id).sort
end

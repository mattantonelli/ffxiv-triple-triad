json.cards do
  json.owned @user_cards.count
  json.missing @total - @user_cards.count
  json.total @total

  json.random_missing do
    json.partial! '/api/cards/card', collection: @random_cards, as: :card
  end
end

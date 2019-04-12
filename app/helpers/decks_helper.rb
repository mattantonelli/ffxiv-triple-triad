module DecksHelper
  def purpose(deck)
    if deck.npc_id.present?
      link_to(deck.npc.name, npc_path(deck.npc))
    elsif deck.rule_id.present?
      deck.rule.name
    else
      'General'
    end
  end

  def usable?(deck, user_cards)
    missing = (deck.cards.pluck(:id) - user_cards).size

    if missing == 0
      fa_icon('check', data: { toggle: 'tooltip', title: 'You have all of the cards in this deck.' })
    else
      fa_icon('times', data: { toggle: 'tooltip',
                               title: "You are missing #{missing} #{'card'.pluralize(missing)} from this deck." })
    end
  end

  def voted?(deck)
    Vote.exists?(deck: deck, user: current_user)
  end

  def card_position(card, user_sort_ids)
    if index = user_sort_ids.index(card.sort_id)
      puts "#{card.name}: #{index}"
      page = (index / 25) + 1
      row = (index % 25 / 5) + 1
      column = (index % 25 % 5) + 1

      "Page #{page}, Row #{row}, Column #{column}"
    else
      'This card is missing from your collection.'
    end
  end
end

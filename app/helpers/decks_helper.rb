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

  def missing_cards(deck, user_cards)
    (deck.cards.pluck(:id) - user_cards).size
  end

  def usable?(deck, user_cards)
    missing = missing_cards(deck, user_cards)

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

  def card_position(card, user_card_ids)
    if index = user_card_ids.index(card.id)
      if card.order_group == 5
        page = 'Last Page'
        row = card.order / 5 + 1
        column = card.order % 5
      else
        page = "Page #{(index / 30) + 1}"
        row = (index % 30 / 5) + 1
        column = (index % 30 % 5) + 1
      end

      "#{page}, Row #{row}, Column #{column}"
    else
      'This card is missing from your collection.'
    end
  end
end

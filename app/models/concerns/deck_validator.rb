class DeckValidator < ActiveModel::Validator
  def validate(deck)
    if deck.cards.size != 5
      deck.errors.add(:cards, :invalid_size)
    end

    if deck.cards.map(&:stars).count { |stars| stars >= 4 } > 1
      puts deck.cards.map(&:id).join(' ')
      deck.errors.add(:cards, :too_many_rares)
    end

    if deck.npc_id.present? && deck.rule_id.present?
      deck.errors.add(:base, :multiple_purposes)
    end
  end
end

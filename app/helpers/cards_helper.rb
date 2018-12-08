module CardsHelper
  def small_image(card)
    image_tag("cards/small/#{card.id}.png")
  end

  def large_image(card)
    image_tag("cards/large/#{card.id}.png")
  end

  def type_image(card)
    id = card.card_type_id
    image_tag("cards/types/#{id}.png") if id > 0
  end

  def stars(card)
    (fa_icon('star') * card.stars).html_safe
  end

  def stat(card, side)
    value = card[side]
    value == 10 ? 'A' : value
  end

  def source(card)
    sources = card.npc_sources.pluck(:name)
    sources << card.source.gsub(/, /, '<br>') if card.source
    sources << link_to(card.pack.name, card_packs_path(nil, anchor: card.pack.id)) if card.pack
    sources << "#{number_with_delimiter(card.buy_price)} MGP" if card.buy_price
    sources.present? ? sources.join('<br>').html_safe : 'TBD'
  end
end

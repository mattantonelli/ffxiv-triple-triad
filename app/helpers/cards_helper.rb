module CardsHelper
  def small_image(card)
    image_tag('blank.png', class: 'small', style: "background-position: -#{40 * (card.id - 1)}px 0")
  end

  def large_image(card)
    image_tag('blank.png', class: 'large', style: "background-position: -#{104 * (card.id - 1)}px 0")
  end

  def type_image(card)
    id = card.card_type_id - 1
    image_tag('blank.png', class: 'type', style: "background-position: -#{20 * id}px 0") if id > -1
  end

  def stars(card)
    (fa_icon('star') * card.stars).html_safe
  end

  def stat(card, side)
    value = card[side]
    value == 10 ? 'A' : value
  end

  def select_tooltip_delay
    '{"show": 500, "hide": 0 }'
  end

  def format_price(price)
    "#{number_with_delimiter(price)} MGP"
  end

  def sources(card)
    sources = card.npc_sources.map { |npc| link_to(npc.name, npc_path(npc)) }
    sources += card.source.split(', ') if card.source
    sources << link_to(card.pack.name, card_packs_path(nil, anchor: card.pack.id)) if card.pack
    sources << format_price(card.buy_price) if card.buy_price
    sources
  end
end

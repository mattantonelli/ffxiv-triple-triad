module CardsHelper
  def small_image(card)
    image_tag('blank.png', class: 'small', style: "background-position: -#{40 * (card.id - 1)}px 0")
  end

  def large_image(card)
    image_tag('blank.png', class: 'large', style: "background-position: -#{104 * (card.id - 1)}px 0")
  end

  def type_image(card)
    if card.card_type_id > 0
      image_tag('blank.png', class: 'type', style: "background-position: -#{20 * (card.card_type_id - 1)}px 0",
                data: { toggle: 'tooltip', placement: 'top', title: card.type.name })
    end
  end

  def stars(card)
    (fa_icon('star') * card.stars).html_safe
  end

  def rarity_options
    (1..5).to_a.reverse.map { |x| ["\u2605" * x, x] }
  end

  def select_tooltip_delay
    '{"show": 500, "hide": 0 }'
  end

  def format_description(card)
    card.description.gsub("\n", '<br>')
      .gsub(/\*(.*?)\*/, '<i>\1</i>')
      .html_safe
  end

  def format_price(price)
    if price > 0
      "#{number_with_delimiter(price)} MGP"
    else
      'N/A'
    end
  end

  def user_ownership(card)
    if user_signed_in?
      owned = current_user.cards.include?(card)

      content_tag(:span, data: { toggle: 'tooltip' }, title: owned ? 'You own this card.' : 'You do not own this card.') do
        fa_icon(owned ? 'check' : 'times')
      end
    end
  end

  def sources(card)
    sources = card.npc_sources.map { |npc| link_to(npc.name, npc_path(npc)) }

    sources += card.sources.pluck(:name).map do |name|
      I18n.t(name.delete('.*'), default: name)
    end

    card.packs.each do |pack|
      sources << link_to(pack.name, packs_path(nil, anchor: pack.id))
    end

    if card.achievement.present?
      sources << link_to(card.achievement.name, "https://ffxivcollect.com/achievements/#{card.achievement.id}",
                         target: '_blank', data: { toggle: 'tooltip' }, title: card.achievement.description)
    end

    sources << format_price(card.buy_price) if card.buy_price
    sources
  end
end

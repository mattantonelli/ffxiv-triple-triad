module CardsHelper
  def small_image(card)
    image_tag("cards/small/#{card.id}.png")
  end

  def large_image(card)
    image_tag("cards/large/#{card.id}.png")
  end

  def stars(card)
    (fa_icon('star') * card.stars).html_safe
  end
end

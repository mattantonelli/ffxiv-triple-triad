module HomeHelper
  def play_guide_link
    region = case(I18n.locale)
             when :fr then 'fr'
             when :de then 'de'
             when :ja then 'jp'
             else 'na'
             end

    link_to("Play Guide #{fa_icon('external-link')}".html_safe,
            "https://#{region}.finalfantasyxiv.com/lodestone/playguide/contentsguide/goldsaucer/tripletriad",
            target: '_blank', class: 'dropdown-item')
  end

  def ffxiv_collect_link
    link_to("FFXIV Collect #{fa_icon('external-link')}".html_safe, 'https://ffxivcollect.com/',
            target: '_blank', class: 'dropdown-item')
  end
end

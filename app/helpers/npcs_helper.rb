module NPCsHelper
  def location(npc, inline: false)
    "#{npc.location.name}#{inline ? ' ' : '<br>'}(#{npc.x}, #{npc.y})".html_safe
  end

  def quest(npc)
    if npc.quest.present?
      link_to(npc.quest.name, "https://www.garlandtools.org/db/#quest/#{npc.quest_id}", target: '_blank')
    end
  end

  def format_rules(npc, inline: false)
    npc.rules.map(&:name).sort.join(inline ? ', ' : '<br>').html_safe
  end

  def difficulty(npc)
    (fa_icon('star') * npc.difficulty.ceil).html_safe
  end

  def npc_defeated?(npc)
    current_user.npcs.include?(npc)
  end

  def npc_rule_options(selected)
    options_for_select(Rule.joins(:npcs).order("name_#{I18n.locale}").uniq.map(&:name), selected)
  end
end

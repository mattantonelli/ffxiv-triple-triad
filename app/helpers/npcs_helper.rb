module NPCsHelper
  def location(npc, inline: false)
    "#{npc.location.name}#{inline ? ' ' : '<br>'}(#{npc.x}, #{npc.y})".html_safe
  end

  def quest(npc)
    if npc.quest.present?
      link_to(npc.quest.name, "https://www.garlandtools.org/db/#quest/#{npc.quest_id}", target: '_blank')
    end
  end

  def format_rules(npc)
    npc.rules.map(&:name).sort.join(', ')
  end
end

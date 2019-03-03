module NPCsHelper
  def location(npc, inline: false)
    "#{npc.location}#{inline ? ' ' : '<br>'}(#{npc.x}, #{npc.y})".html_safe
  end

  def quest(npc)
    link_to(npc.quest, "https://www.garlandtools.org/db/#quest/#{npc.quest_id}", target: '_blank') if npc.quest
  end

  def format_rules(npc)
    npc.rules.map(&:name).sort.join(', ')
  end
end

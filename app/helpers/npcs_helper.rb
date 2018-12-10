module NPCsHelper
  def location(npc)
    "#{npc.location}<br>(#{npc.x}, #{npc.y})".html_safe
  end

  def quest(npc)
    link_to(npc.quest, "http://www.garlandtools.org/db/#quest/#{npc.quest_id}", target: '_blank') if npc.quest
  end
end

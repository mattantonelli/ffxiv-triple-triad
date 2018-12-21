# == Schema Information
#
# Table name: npcs
#
#  id          :bigint(8)        not null, primary key
#  name        :string(255)      not null
#  location    :string(255)
#  x           :integer
#  y           :integer
#  rules       :string(255)
#  quest       :string(255)
#  resident_id :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  quest_id    :integer
#  patch       :string(255)
#

class NPC < ApplicationRecord
  has_many :npc_cards
  has_many :npc_rewards
  has_many :cards, through: :npc_cards
  has_many :fixed_cards, -> { where('npc_cards.fixed = true') }, through: :npc_cards, source: :card
  has_many :variable_cards, -> { where('npc_cards.fixed = false') }, through: :npc_cards, source: :card
  has_many :rewards, through: :npc_rewards, source: :card
end

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
  has_and_belongs_to_many :users

  def self.locations
    {
      'La Noscea'         => ['Limsa', 'Noscea'],
      'The Black Shroud'  => ['Gridania', 'Shroud'],
      'Thanalan'          => ["Ul'dah", 'Thanalan', 'Gold Saucer', 'Battlehall'],
      'Mor Dhona'         => ['Mor Dhona'],
      'Coerthas'          => ['Foundation', 'Coerthas', 'Pillars', 'Fortemps'],
      "Abalathia's Spire" => ['Clouds', 'Azys'],
      'Dravania'          => ['Idyllshire', 'Forelands', 'Hinterlands', 'Churning'],
      'Gyr Abania'        => ["Rhalgr's", 'Fringes', 'Peaks', 'Lochs'],
      'Hingashi'          => ['Kugane'],
      'Othard'            => ['Ruby Sea', 'Yanxia', 'Azim', 'Doman']
    }.freeze
  end
end

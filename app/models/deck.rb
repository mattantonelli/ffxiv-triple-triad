# == Schema Information
#
# Table name: decks
#
#  id         :bigint(8)        not null, primary key
#  user_id    :integer
#  rule_id    :integer
#  npc_id     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Deck < ApplicationRecord
  before_create :set_order

  belongs_to :user
  belongs_to :rule, required: false
  belongs_to :npc, required: false
  has_many :deck_cards, dependent: :delete_all
  has_many :cards, through: :deck_cards

  validates_with DeckValidator
  validates :rule, presence: true, unless: -> { rule_id.blank? }
  validates :npc,  presence: true, unless: -> { npc_id.blank? }

  private
  def set_order
    deck_cards.each_with_index do |card, i|
      card.position = i + 1
    end
  end
end

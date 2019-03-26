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
  belongs_to :user
  belongs_to :rule, required: false
  belongs_to :npc, required: false
  has_and_belongs_to_many :cards
end

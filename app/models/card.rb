# == Schema Information
#
# Table name: cards
#
#  id           :bigint(8)        not null, primary key
#  name         :string(255)      not null
#  description  :text(65535)      not null
#  patch        :string(255)      not null
#  card_type_id :integer          not null
#  stars        :integer          not null
#  top          :integer          not null
#  right        :integer          not null
#  bottom       :integer          not null
#  left         :integer          not null
#  buy_price    :integer
#  sell_price   :integer          not null
#  source       :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Card < ApplicationRecord
  has_one :card_type
  has_many :npc_rewards
  has_many :npc_sources, through: :npc_rewards, source: :npc
end

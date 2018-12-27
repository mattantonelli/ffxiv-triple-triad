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
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  sort_id      :integer
#

class Card < ApplicationRecord
  belongs_to :type, class_name: 'CardType', foreign_key: :card_type_id
  has_many :npc_rewards
  has_many :npc_sources, through: :npc_rewards, source: :npc
  has_many :sources
  has_one :pack_card
  has_one :pack, through: :pack_card

  def stats
    "#{top} #{right} #{bottom} #{left}".gsub(/10/, 'A')
  end
end

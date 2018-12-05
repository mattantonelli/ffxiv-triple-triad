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
  belongs_to :type, class_name: 'CardType', foreign_key: :card_type_id
  has_many :npc_rewards
  has_many :npc_sources, through: :npc_rewards, source: :npc

  def stats
    "#{top} #{right} #{bottom} #{left}".gsub(/10/, 'A')
  end
end

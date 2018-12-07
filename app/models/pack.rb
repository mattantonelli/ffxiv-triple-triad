# == Schema Information
#
# Table name: packs
#
#  id         :bigint(8)        not null, primary key
#  name       :string(255)      not null
#  cost       :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Pack < ApplicationRecord
  has_many :pack_cards
  has_many :cards, through: :pack_cards
end

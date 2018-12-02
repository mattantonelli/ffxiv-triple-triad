# == Schema Information
#
# Table name: card_types
#
#  id         :bigint(8)        not null, primary key
#  name       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class CardType < ApplicationRecord
  has_many :cards
end

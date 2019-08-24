# == Schema Information
#
# Table name: achievements
#
#  id             :bigint(8)        not null, primary key
#  name_en        :string(255)
#  name_de        :string(255)
#  name_fr        :string(255)
#  name_ja        :string(255)
#  description_en :string(255)
#  description_de :string(255)
#  description_fr :string(255)
#  description_ja :string(255)
#  card_id        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Achievement < ApplicationRecord
  belongs_to :card
  translates :name, :description
end

# == Schema Information
#
# Table name: sources
#
#  id         :bigint(8)        not null, primary key
#  card_id    :integer
#  origin     :string(255)
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Source < ApplicationRecord
  belongs_to :card

  def self.names
    %w(NPC Dungeon Trial Raid FATE Pack Achievement Tournament Other)
  end
end

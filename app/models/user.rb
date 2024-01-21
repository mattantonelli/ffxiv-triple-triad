# == Schema Information
#
# Table name: users
#
#  id                 :bigint(8)        not null, primary key
#  username           :string(255)
#  discriminator      :integer
#  avatar_url         :string(255)
#  provider           :string(255)
#  uid                :string(255)
#  sign_in_count      :integer          default(0), not null
#  current_sign_in_at :datetime
#  last_sign_in_at    :datetime
#  current_sign_in_ip :string(255)
#  last_sign_in_ip    :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  public_cards       :boolean          default(TRUE)
#  admin              :boolean          default(FALSE)
#

class User < ApplicationRecord
  has_many :decks, primary_key: :uid, foreign_key: :user_uid
  has_many :votes
  has_and_belongs_to_many :cards
  has_and_belongs_to_many :npcs

  devise :timeoutable, :trackable, :omniauthable, omniauth_providers: [:discord]

  scope :visible, -> { where(public_cards: true) }
  scope :active,  -> { joins(:cards).group(:id).having('count(cards.id) > 5').visible }

  def add_card(card_id)
    cards << Card.find(card_id)
  end

  def remove_card(card_id)
    cards.delete(card_id)
  end

  def set_cards(card_ids)
    self.cards = Card.where(id: card_ids)
  end

  def add_npc(npc_id)
    npcs << NPC.find(npc_id)
  end

  def remove_npc(npc_id)
    npcs.delete(npc_id)
  end

  def add_defeated_npcs
    # Find the IDs for all NPCs from whom the user has obtained exclusive cards,
    # those that are available from that NPC and nowhere else
    ids = Card.joins(npc_rewards: :npc)
      .left_joins(:sources).where('sources.id is null')
      .left_joins(:pack_cards).where('pack_cards.id is null')
      .where(buy_price: nil)
      .group('npc_rewards.card_id').having('count(npc_rewards.npc_id) = 1')
      .where(id: cards).distinct
      .select('npcs.id as id').map { |card| card.id }

    # Add the existing defeated NPC IDs
    ids += npcs.pluck(:id)

    self.npcs = NPC.where(id: ids.uniq) unless ids.empty?
  end

  def self.from_omniauth(auth)
    # Clean up any special characters in the username
    username = auth.info.name.encode(Encoding.find('ASCII'), invalid: :replace, undef: :replace, replace: '')

    discord_user = User.find_by(provider: auth.provider, uid: auth.uid)
    attributes = { username: username, avatar_url: auth.info.image }

    if discord_user.present?
      discord_user.update!(attributes)
    else
      discord_user = User.create!(attributes.merge(provider: auth.provider, uid: auth.uid))
    end

    discord_user
  end

  private
  def cards_key
    "user-#{id}-cards"
  end

  def npcs_key
    "user-#{id}-npcs"
  end
end

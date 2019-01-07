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
  devise :trackable, :omniauthable, omniauth_providers: [:discord]

  def cards
    Redis.current.smembers(cards_key).map(&:to_i)
  end

  def add_card(card_id)
    Redis.current.sadd(cards_key, card_id)
  end

  def remove_card(card_id)
    Redis.current.srem(cards_key, card_id)
  end

  def set_cards(card_ids)
    Redis.current.del(cards_key)
    Redis.current.sadd(cards_key, card_ids) unless card_ids.empty?
  end

  def self.from_omniauth(auth)
    # Clean up any special characters in the username
    username = auth.info.name.encode(Encoding.find('ASCII'), { invalid: :replace, undef: :replace, replace: '' })

    discord_user = where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.username = username
      user.discriminator = auth.extra.raw_info.discriminator
      user.avatar_url = auth.info.image
    end

    # Keep existing Discord users' data up to date
    if discord_user.persisted?
      discord_user.update(username: username,
                          discriminator: auth.extra.raw_info.discriminator,
                          avatar_url: auth.info.image)
    end

    discord_user
  end

  private
  def cards_key
    "user-#{id}-cards"
  end
end

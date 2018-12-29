module Admin::UsersHelper
  def username(user)
    "#{user.username}##{user.discriminator.to_s.rjust(4, '0')}"
  end
end

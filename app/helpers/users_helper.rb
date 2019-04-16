module UsersHelper
  def early_user?(user)
    user.created_at < Time.parse('Jan 20, 2019')
  end
end

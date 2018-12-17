class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def discord
    @user = User.from_omniauth(request.env['omniauth.auth'])
    sign_in(@user)
    redirect_to my_cards_path
  end
end

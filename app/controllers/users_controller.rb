class UsersController < ApplicationController
  before_action :set_user!, only: [:edit, :update]

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:success] = 'Your settings have been updated.'
      redirect_to user_settings_path
    else
      flash[:error] = 'There was a problem updating your settings.'
      render :edit
    end
  end

  private
  def set_user!
    if user_signed_in?
      @user = current_user
    else
      flash[:alert] = 'You must sign in to manage your settings.'
      redirect_to root_path
    end
  end

  def user_params
    params.require(:user).permit(:public_cards)
  end
end

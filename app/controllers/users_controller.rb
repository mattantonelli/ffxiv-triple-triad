class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update]
  before_action :validate_user!

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:success] = 'Your settings have been updated.'
      redirect_to edit_user_path(@user)
    else
      flash[:error] = 'There was a problem updating your settings.'
      render :edit
    end
  end

  private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:public_cards)
  end

  def validate_user!
    if user_signed_in?
      redirect_to edit_user_path(current_user) unless @user == current_user
    else
      flash[:alert] = 'You must sign in to manage your settings.'
      redirect_to root_path
    end
  end
end

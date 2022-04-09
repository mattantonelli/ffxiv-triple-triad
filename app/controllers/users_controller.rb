class UsersController < ApplicationController
  before_action :set_user!, except: :show

  def show
    @user = User.find_by(uid: params[:uid])
    return redirect_to not_found_path unless @user.present?

    if @user.public_cards? || @user == current_user
      @ownership = Redis.current.hgetall(:ownership)
      @cards = @user.cards.sort_by { |card| @ownership.fetch(card.id.to_s, '0%').delete('%').to_i }
      @defeated_npcs = @user.npcs.valid
      @total_npcs = NPC.valid.count
    else
      flash[:error] = 'This user has set their collection to private.'
      redirect_to root_path
    end
  end

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

  def import
  end

  def submit
    card_ids = import_params[:code].split(',')

    if card_ids.present? && card_ids.all? { |id| id =~ /\A\d+\z/ }
      current_user.cards = Card.where(id: card_ids)
      flash[:success] = 'Your card collection has been imported successfully.'
      redirect_to cards_path
    else
      flash[:error] = 'There was a problem importing your collection. Please check your code and try again.'
      render :import
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

  def import_params
    params.require(:user).permit(:code)
  end
end

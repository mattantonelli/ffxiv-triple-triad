class Api::UsersController < ApplicationController
  def show
    @user = User.find_by(uid: params[:id])

    if @user.public_cards
      @total = Card.count
      @user_cards = @user.cards

      random_ids = ((1..@total).to_a - @user_cards).sample(params[:limit].to_i || 5)
      @random_cards = Card.includes(:type, :npc_sources, :pack).where(id: random_ids).order(:patch, :id)
    else
      render json: { status: 403, error: "User's card collection is set to private" }, status: :forbidden
    end
  end
end

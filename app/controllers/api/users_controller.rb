class Api::UsersController < ApiController
  def show
    @user = User.find_by(uid: params[:id])

    if !@user.present?
      render json: { status: 404, error: 'Not found' }, status: :not_found
    elsif !@user.public_cards
      render json: { status: 403, error: "User's card collection is set to private" }, status: :forbidden
    else
      @total = Card.count
      @user_cards = @user.cards.pluck(:id)

      limit = params[:limit_missing].present? ? params[:limit_missing].to_i : 5
      random_ids = (Card.pluck(:id) - @user_cards).sample(limit)
      @random_cards = Card.includes(:type, :npc_sources, :sources, :pack).where(id: random_ids).order(:patch, :id)
    end
  end
end

class Api::UsersController < ApiController
  def show
    @user = User.find_by(uid: params[:id])

    if !@user.present?
      render json: { status: 404, error: "User not found. Sign up at #{root_url}" }, status: :not_found
    elsif !@user.public_cards
      render json: { status: 403, error: "User's card collection is set to private" }, status: :forbidden
    else
      @total_cards = Card.count
      @user_cards = @user.cards.pluck(:id)
      @card_completion = (@user_cards.size / @total_cards.to_f) * 100

      limit = params[:limit_missing].present? ? params[:limit_missing].to_i : 5
      random_ids = (Card.pluck(:id) - @user_cards).sample(limit)
      @random_cards = Card.includes(:type, :sources, :packs, :achievement, npc_sources: [:location, :quest, :rules])
        .where(id: random_ids).order(:patch, :id)

      @user_npcs = @user.npcs
      @total_npcs = NPC.valid.count
      @defeated_npcs = @user_npcs.valid.count
      @npc_completion = (@defeated_npcs / @total_npcs.to_f) * 100
    end
  end
end

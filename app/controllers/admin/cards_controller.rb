class Admin::CardsController < AdminController
  before_action :set_card, only: [:edit, :update]

  def index
    @q = Card.all.ransack(params[:q])
    @cards = @q.result.includes(:npc_sources, :sources, :packs, :achievement)
      .order(patch: :desc, order_group: :desc, order: :desc)
      .paginate(page: params[:page])
  end

  def edit
    build_sources
  end

  def update
    update_params = card_params
    update_params[:sources_attributes].reject! { |_, source| source[:origin].blank? || source[:name].blank? }

    if @card.update(update_params)
      flash[:success] = 'Card has been updated.'
      redirect_to edit_admin_card_path(@card)
    else
      flash[:error] = 'There was a problem updating the card.'
      build_sources
      render :edit
    end
  end

  def delete_sources
    @card = Card.find(params[:card_id])
    @card.sources.delete_all

    flash[:success] = 'Card sources have been deleted.'
    redirect_to edit_admin_card_path(@card)
  end

  private
  def set_card
    @card = Card.find(params[:id])
  end

  def build_sources
    2.times { @card.sources.build }
  end

  def card_params
    params.require(:card).permit(:name, :buy_price, :patch, sources_attributes: [:id, :card_id, :origin, :name])
  end
end

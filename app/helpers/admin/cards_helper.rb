module Admin::CardsHelper
  def origin_options
    Source.origins - %w(NPC Pack MGP Achievement)
  end
end

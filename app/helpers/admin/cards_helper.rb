module Admin::CardsHelper
  def origin_options
    Source.origins - %w(NPC Pack MGP)
  end
end

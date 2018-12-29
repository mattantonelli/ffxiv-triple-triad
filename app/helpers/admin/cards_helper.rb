module Admin::CardsHelper
  def origin_options
    Source.origins - ['NPC', 'Pack']
  end
end

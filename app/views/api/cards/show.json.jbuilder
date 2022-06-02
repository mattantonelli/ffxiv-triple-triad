json.cache! [@card, I18n.locale] do
  json.partial! 'card', card: @card, ownership: @ownership
end

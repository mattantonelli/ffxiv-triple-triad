json.query @query_params
json.count @packs.count
json.results do
  json.cache! [@packs, I18n.locale] do
    json.partial! 'pack', collection: @packs, as: :pack
  end
end

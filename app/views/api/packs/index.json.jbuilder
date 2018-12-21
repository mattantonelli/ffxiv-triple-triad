json.query @query_params
json.count @packs.count
json.results do
  json.partial! 'pack', collection: @packs, as: :pack
end

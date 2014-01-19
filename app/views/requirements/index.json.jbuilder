json.array!(@requirements) do |requirement|
  json.extract! requirement, :id, :name, :app_id
  json.url requirement_url(requirement, format: :json)
end

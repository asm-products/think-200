json.array!(@expectations) do |expectation|
  json.extract! expectation, :id, :subject, :matcher_id, :expectation, :requirement_id
  json.url expectation_url(expectation, format: :json)
end

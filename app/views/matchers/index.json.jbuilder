json.array!(@matchers) do |matcher|
  json.extract! matcher, :id, :code, :min_args, :max_args
  json.url matcher_url(matcher, format: :json)
end

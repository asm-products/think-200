json.array!(@spec_runs) do |spec_run|
  json.extract! spec_run, :id, :raw_data, :passed, :project_id
  json.url spec_run_url(spec_run, format: :json)
end

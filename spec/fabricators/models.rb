Fabricator(:user) do
  id       { (rand * 1000000).to_i }
  username { "user#{rand(1000000)}" }  # Couldn't get sequences to work
  email    { "mailbox#{rand(1000000)}@example.com" }
  password 'password'
end

Fabricator(:project) do
  id   { (rand * 1000000).to_i }
  name 'Lewis & Clark College'
  user
end

Fabricator(:app) do
  id   { (rand * 1000000).to_i }
  name 'api'
  project
end

Fabricator(:requirement) do
  id   { (rand * 1000000).to_i }
  name 'is online'
  app
end

Fabricator(:expectation) do
  subject     Faker::Internet.domain_name
  matcher     Matcher.find_by_code('be_up')
  requirement
end

failed_examples = { 888 => {
                      :examples=>
                      [
                        {:description=>"does this rspec",
                         :full_description=>"encapsulated does this rspec",
                         :status=>"failed",
                         :file_path=>"/tmp/rspec20140319-2116-91ixcz",
                         :line_number=>4,
                         :exception=>
                         {:class=>"RSpec::Expectations::ExpectationNotMetError",
                          :message=>
                          "Received status 302 instead of 301; destination uses protocol http; there's no valid ssl certificate"}}],
                      :summary=>
                      {
                        :duration=>5.888451936,
                        :example_count=>1,
                        :failure_count=>1,
                        :pending_count=>0
                      },
                      :summary_line=>"1 example, 1 failure"
                    }
                    }

passed_examples = {
  333=>
  {
    :examples=>
    [{:description=>"does this rspec",
      :full_description=>"encapsulated does this rspec",
      :status=>"passed",
      :file_path=>"/tmp/rspec20140316-17211-1u2gd68",
      :line_number=>4}],
    :summary=>
    {
      :duration=>0.024736337,
      :example_count=>1,
      :failure_count=>0,
      :pending_count=>0
    },
  :summary_line=>"1 example, 0 failures"},

  111=>
  {
    :examples=>
    [{:description=>"does this rspec",
      :full_description=>"encapsulated does this rspec",
      :status=>"passed",
      :file_path=>"/tmp/rspec20140316-17211-1lxntyb",
      :line_number=>4}],
    :summary=>
    {
      :duration=>0.241699992,
      :example_count=>1,
      :failure_count=>0,
      :pending_count=>0
    },
    :summary_line=>"1 example, 0 failures"
  },

  222=>
  {:examples=>
   [{:description=>"does this rspec",
     :full_description=>"encapsulated does this rspec",
     :status=>"passed",
     :file_path=>"/tmp/rspec20140316-17211-lja33o",
     :line_number=>4}],
   :summary=>
   {:duration=>0.013908195,
    :example_count=>1,
    :failure_count=>0,
    :pending_count=>0},
   :summary_line=>"1 example, 0 failures"}
}


Fabricator(:spec_run_all_failed, from: :spec_run) do
  id   { (rand * 1000000).to_i }
  raw_data { failed_examples }
  project
end

Fabricator(:spec_run_all_passed, from: :spec_run) do
  id   { (rand * 1000000).to_i }
  raw_data { passed_examples }
  project
end

Fabricator(:spec_run_mixed_results, from: :spec_run) do
  id   { (rand * 1000000).to_i }
  raw_data { passed_examples.merge(failed_examples) }
  project
end
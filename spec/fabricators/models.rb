Fabricator(:user) do
  username { "user#{rand(1000000)}" }  # Couldn't get sequences to work
  email    { "mailbox#{rand(1000000)}@example.com" }
  password 'password'
end

Fabricator(:project) do
  name 'Lewis & Clark College'
  user
end

Fabricator(:app) do
  name 'api'
  project
end

Fabricator(:requirement) do
  name 'is online'
  app
end

Fabricator(:expectation) do
  subject     Faker::Internet.domain_name
  matcher     Matcher.find_by_code('be_up')
  requirement
end

failed_examples = { 8 => {
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


Fabricator(:spec_run_all_failed, from: :spec_run) do
  raw_data { failed_examples }
  project
end

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

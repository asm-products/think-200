Fabricator(:user) do
  username 'phoebe'
  email 'phoebe@lclark.edu'
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

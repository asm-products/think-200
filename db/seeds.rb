# Generated with RailsBricks
# Initial seed file to use with Devise User Model

# Temporary admin account
u = User.new(
  username: "admin",
  email: "admin@example.com",
  password: "1234",
  password_confirmation: "1234",
  admin: true
)
u.skip_confirmation!
u.save!

# The 'robb' user
robb = User.new(
                username: 'robb',
                email:    'robb@weblaws.org',
                password: '1234',
                password_confirmation: '1234',
                admin: true
                )
robb.skip_confirmation!
robb.save!

# Robb's data
puts 'Creating Quisitive project...'
quisitive = Project.create!(name: 'Quisitive', user: robb)

api       = App.create!(name: 'API',            project: quisitive)
website   = App.create!(name: 'Website',        project: quisitive)
listing   = App.create!(name: 'iTunes Listing', project: quisitive)

is_online = Requirement.create!(name: 'is online', app: website)
root_dn   = Requirement.create!(name: 'serves from the root domain', app: website)

redirect1 = Expectation.create!(
  subject:     'www.getquisitive.com',
  matcher:     Matcher.find_by_code('redirect_permanently_to'),
  expected:    'getquisitive.com/',
  requirement: root_dn
)
redirect1 = Expectation.create!(
  subject:     'www.getquisitive.com/press-kit/',
  matcher:     Matcher.find_by_code('redirect_permanently_to'),
  expected:    'getquisitive.com/press-kit/',
  requirement: root_dn
)
redirect3 = Expectation.create!(
  subject:     'getquisitive.com',
  matcher:     Matcher.for('be_up'),
  requirement: is_online
)


# The 'My App' demo code
puts 'Creating Orion project...'
think200   = Project.create!(name: 'Orion', user: robb)
myapp      = App.create!(name: 'Website', project: think200)

is_online  = Requirement.create!(name: 'is online', app: myapp)
valid_cert = Requirement.create!(name: 'is correctly configured for ssl', app: myapp)
to_www     = Requirement.create!(name: 'redirects to www', app: myapp)

Expectation.create!(
  subject:     'www.myapp.com/',
  matcher:     Matcher.for('be_up'),
  requirement: is_online
)

Expectation.create!(
  subject:     'www.myapp.com/about',
  matcher:     Matcher.for('be_status'),
  expected:    '200',
  requirement: is_online
)

Expectation.create!(
  subject:     'www.myapp.com',
  matcher:     Matcher.for('have_a_valid_cert'),
  requirement: valid_cert
)

Expectation.create!(
  subject:     'http://myapp.com',
  matcher:     Matcher.for('redirect_permanently_to'),
  expected: 'http://www.myapp.com/',
  requirement: to_www
)

Expectation.create!(
  subject:     'myapp.com',
  matcher:     Matcher.for('enforce_https_everywhere'),
  requirement: valid_cert
)


#
# Project: CodePage.io
#
puts 'Creating CodePage.io project...'
codepage    = Project.create!(name: 'CodePage.io', user: robb)
website     = App.create!(name: 'website', project: codepage)
on_assembly = Requirement.create!(name: 'is hosted by Assembly', app: website)
Expectation.create!(
  subject:     'http://codepage.io',
  matcher:     Matcher.for('redirect_temporarily_to'),
  expected:    'https://assemblymade.com/code-pagecodepageio',
  requirement: on_assembly
)
Expectation.create!(
  subject:     'https://assemblymade.com/code-pagecodepageio',
  matcher:     Matcher.for('be_status'),
  expected:    '200',
  requirement: on_assembly
)


puts "Creating unfinished projects..."
# Projects in an unfinished state
Project.create!(name: 'Best Korea',  user: robb)

# Project in a Semi-finished state
think_200 = Project.create!(name: APP_NAME, user: robb)
t200_api  = App.create!(name: 'API', project: think_200)
t200_site = App.create!(name: 'website', project: think_200)
Requirement.create!(name: 'is online', app: t200_site)


users_amount = 10
User.transaction do
  (1..users_amount).each do |i|
    u = User.new(
                 username: "user#{i}",
                 email: "user#{i}@example.com",
                 password: "1234",
                 password_confirmation: "1234"
                 )
    u.skip_confirmation!
    u.save!

    puts "#{i} of #{users_amount} test users created..." if (i % 10 == 0)
  end
end



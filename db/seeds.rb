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
)
robb.skip_confirmation!
robb.save!

puts 'Creating the Matchers...'
[
  {
    code: 'be_status',
    min_args: 1,
    max_args: 1,
    summary: 'Pass if the domain/url has the given status.',
    description: 'Uses curl_lib.',
    icon: 'fa-stethoscope',
    placeholder: '200'
  },
  {
    code: 'be_up',
    min_args: 0,
    max_args: 0,
    summary: 'Follows redirects if necessary and checks for 200',
    description: 'Uses curl_lib.',
    icon: 'fa-thumbs-o-up',
  },
  {
    code: 'have_a_valid_cert',
    min_args: 0,
    max_args: 0,
    summary: 'Serves HTTPS correctly.',
    description: 'Uses curl_lib.',
    icon: 'fa-lock'
  },
  {
    code: 'enforce_https_everywhere',
    min_args: 0,
    max_args: 0,
    summary: 'Forces visitors to use HTTPS.',
    description: 'Uses curl_lib.',
    icon: 'fa-globe'
  },
  {
    code: 'redirect_permanently_to',
    min_args: 1,
    max_args: 1,
    summary: 'Checks for a 301 redirect to a given location.',
    description: 'Uses curl_lib.',
    icon: 'fa-level-down fa-rotate-270',
    placeholder: 'somewhere.com'
  },
  {
    code: 'redirect_temporarily_to',
    min_args: 1,
    max_args: 1,
    summary: 'Checks for either a 302 or 307 redirect to a given location.',
    description: 'Uses curl_lib.',
    icon: 'fa-share',
    placeholder: 'somewhere.else.com'
  }
].each do |m|
  matcher = Matcher.new
  matcher.code        = m[:code]
  matcher.min_args    = m[:min_args]
  matcher.max_args    = m[:max_args]
  matcher.summary     = m[:summary]
  matcher.description = m[:description]
  matcher.icon        = m[:icon]
  matcher.placeholder = m[:placeholder]
  matcher.save!
end


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
  matcher:     Matcher.find_by_code('be_up'),
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
  matcher:     Matcher.find_by_code('be_up'),
  requirement: is_online
)

Expectation.create!(
  subject:     'www.myapp.com/about',
  matcher:     Matcher.find_by_code('be_status'),
  expected:    '200',
  requirement: is_online
)

Expectation.create!(
  subject:     'www.myapp.com',
  matcher:     Matcher.find_by_code('have_a_valid_cert'),
  requirement: valid_cert
)

Expectation.create!(
  subject:     'http://myapp.com',
  matcher:     Matcher.find_by_code('redirect_permanently_to'),
  expected: 'http://www.myapp.com/',
  requirement: to_www
)

Expectation.create!(
  subject:     'myapp.com',
  matcher:     Matcher.find_by_code('enforce_https_everywhere'),
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
  matcher:     Matcher.find_by_code('redirect_temporarily_to'),
  expected:    'https://assemblymade.com/code-pagecodepageio',
  requirement: on_assembly
)
Expectation.create!(
  subject:     'https://assemblymade.com/code-pagecodepageio',
  matcher:     Matcher.find_by_code('be_status'),
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


users_amount = 200
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



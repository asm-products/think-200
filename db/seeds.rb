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

# The matchers
[
  {
    code: 'be_status',                
    min_args: 1, 
    max_args: 1, 
    summary: 'Pass if the domain/url has the given status.', 
    description: 'Uses curl_lib.'
    },
  {
    code: 'be_up',                    
    min_args: 0, 
    max_args: 0,
    summary: 'Follows redirects if necessary and checks for 200',
    description: 'Uses curl_lib.'
    },
  {
    code: 'have_a_valid_cert',        
    min_args: 0, 
    max_args: 0,
    summary: 'Serves HTTPS correctly.',
    description: 'Uses curl_lib.'
    },
  {
    code: 'enforce_https_everywhere', 
    min_args: 0, 
    max_args: 0,
    summary: 'Forces visitors to use HTTPS.',
    description: 'Uses curl_lib.'
    },
  {
    code: 'redirect_permanently_to',  
    min_args: 1, 
    max_args: 1,
    summary: 'Checks for a 301 redirect to a given location.',
    description: 'Uses curl_lib.'
    },
  {
    code: 'redirect_temporarily_to',  
    min_args: 1, 
    max_args: 1,
    summary: 'Checks for either a 302 or 307 redirect to a given location.',
    description: 'Uses curl_lib.'
  }
].each do |m|
  matcher = Matcher.new
  matcher.code        = m[:code]
  matcher.min_args    = m[:min_args]
  matcher.max_args    = m[:max_args]
  matcher.summary     = m[:summary]
  matcher.description = m[:description]
  matcher.save!
end


# Robb's data
puts 'Creating Quisitive data...'
quisitive = Project.create!(name: 'Quisitive', user: robb)

api       = App.create!(name: 'API',            project: quisitive)
website   = App.create!(name: 'Website',        project: quisitive)
listing   = App.create!(name: 'iTunes Listing', project: quisitive)

is_online = Requirement.create!(name: 'is online', app: website)
root_dn   = Requirement.create!(name: 'serves from root domain', app: website)

redirect1 = Expectation.create!(
  subject:     'http://www.getquisitive.com', 
  matcher:     Matcher.find_by_code('redirect_permanently_to'),
  expected:    'http://getquisitive.com/',
  requirement: root_dn
  )
redirect1 = Expectation.create!(
  subject:     'http://www.getquisitive.com/press-kit/', 
  matcher:     Matcher.find_by_code('redirect_permanently_to'),
  expected:    'http://getquisitive.com/press-kit/',
  requirement: root_dn
  )
redirect3 = Expectation.create!(
  subject:     'getquisitive.com', 
  matcher:     Matcher.find_by_code('be_up'),
  requirement: is_online
  )


# The 'My App' demo code
think200   = Project.create!(name: 'Demo App', user: robb)
myapp      = App.create!(name: 'My App', project: think200)

is_online  = Requirement.create!(name: 'is online', app: myapp)
valid_cert = Requirement.create!(name: 'is correctly configured for ssl', app: myapp)
to_www     = Requirement.create!(name: 'redirects to www', app: myapp)
https_only = Requirement.create!(name: 'forces visitors to use https', app: myapp)

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
  requirement: https_only
  )


# Projects in an unfinished state
Project.create!(name: 'Best Korea',  user: robb)
Project.create!(name: 'CodePage.io', user: robb)

# Semi-finished
think_200 = Project.create!(name: 'Think 200', user: robb)
t200_api  = App.create!(name: 'API', project: think_200)
t200_site = App.create!(name: 'website', project: think_200)
Requirement.create!(name: 'is online', app: t200_site)


# Prompt for test data
# STDOUT.puts
# STDOUT.print "Do you want to seed test data?(y/n):"
# result = STDIN.gets.chomp
result = 'y'

if result == "y"
  
  # Test user accounts
  # STDOUT.puts
  # STDOUT.print "How many test users?:"
  # users_amount = STDIN.gets.chomp.to_i
  users_amount = 20
  (1..users_amount).each do |i|
    u = User.new(
      username: "user#{i}",
      email: "user#{i}@example.com",
      password: "1234",
      password_confirmation: "1234"
    )
    u.skip_confirmation!
    u.save!
    
    puts "#{i} test users created..." if (i % 10 == 0)
  end
  
end

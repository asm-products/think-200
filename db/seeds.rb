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
  {code: 'be_status',                min_args: 1, max_args: 1},
  # {code: 'be_up',                    min_args: 0, max_args: 0},  # Coming soon
  {code: 'have_a_valid_cert',        min_args: 0, max_args: 0},
  {code: 'enforce_https_everywhere', min_args: 0, max_args: 0},
  {code: 'redirect_permanently_to',  min_args: 1, max_args: 1},
  {code: 'redirect_temporarily_to',  min_args: 1, max_args: 1}
].each do |m|
  matcher = Matcher.new
  matcher.code     = m[:code]
  matcher.min_args = m[:min_args]
  matcher.max_args = m[:max_args]
  matcher.save!
end


# Robb's data
puts 'Creating Quisitive data...'
quisitive = Project.create!(name: 'Quisitive', user: robb)

api       = App.create!(name: 'API',            project: quisitive)
website   = App.create!(name: 'Website',        project: quisitive)
listing   = App.create!(name: 'iTunes Listing', project: quisitive)

is_fast   = Requirement.create!(name: 'is fast', app: website)
root_dn   = Requirement.create!(name: 'serves from root domain', app: website)

redirect1 = Expectation.create!(
  subject:     'http://www.getquisitive.com', 
  matcher:     Matcher.find_by_code('redirect_permanently_to'),
  expectation: 'http://getquisitive.com/',
  requirement: root_dn
  )
redirect2 = Expectation.create!(
  subject:     'https://www.getquisitive.com', 
  matcher:     Matcher.find_by_code('redirect_permanently_to'),
  expectation: 'https://getquisitive.com/',
  requirement: root_dn
  )
redirect3 = Expectation.create!(
  subject:     'http://www.getquisitive.com/press-kit/', 
  matcher:     Matcher.find_by_code('redirect_permanently_to'),
  expectation: 'http://getquisitive.com/press-kit/',
  requirement: root_dn
  )




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

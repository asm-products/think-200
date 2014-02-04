require 'think200_jobs'

namespace :think200 do
  desc 'Test all projects which are authorized for this service.'
  task :test_all_projects => :environment do
    Think200.test_all_projects
  end
end

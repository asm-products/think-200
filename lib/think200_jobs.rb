require 'tempfile'
require 'rspec'
require 'rspec/core/formatters/json_formatter'


module Think200

  STANDARD_QUEUE = :standard
  PREMIUM_QUEUE  = :premium


  # Run a project's specs. Use like this:
  # `Resque.enqueue_to(STANDARD_QUEUE, ManualTest, project_id: 1, user_id: 2)`
  class ManualTest
    include Resque::Plugins::UniqueJob
    @queue = STANDARD_QUEUE

    def self.perform(project_id, user_id)
      Think200::run_test(project_id: project_id, user_id: user_id, manual: true)
    end
  end


  # Also run a project's tests, but intended to be done from a cron job.
  class ScheduledTest
    include Resque::Plugins::UniqueJob
    @queue = PREMIUM_QUEUE

    def self.perform(project_id, user_id)
      Think200::run_test(project_id: project_id, user_id: user_id, manual: false)
    end
  end


  # Enqueue all projects for testing in the premium queue. This is intended to be                             
  # executed from a cron job / rake task.                                                                     
  def self.test_all_projects
    Project.find_each do |p|
      proj_desc = "project #{p.id} / #{p.name}"
      begin
        p.queue_for_testing
        puts "Queued for testing: #{proj_desc}"
      rescue Exception => e
        $stderr.puts "Could not enqueue project #{proj_desc}: #{e}"
      end
    end
  end


  private

  def self.run_test(project_id: nil, user_id: nil, manual: nil)
    begin
      user = User.find(user_id)
      proj = user.projects.find(project_id)
      return if proj.expectations.empty?
    rescue ActiveRecord::RecordNotFound
      raise "#{user} doesn't have a project number #{project_id}"
    end

    collected_results = {}
    proj.expectations.each do |expectation|
      # Create an rspec file
      file = Tempfile.new('rspec')
      file.write(expectation.to_encapsulated_rspec)
      file.close

      # Prepare the rspec runner
      config = RSpec.configuration
      json_formatter = RSpec::Core::Formatters::JsonFormatter.new(config.out)
      reporter = RSpec::Core::Reporter.new(json_formatter)
      config.instance_variable_set(:@reporter, reporter)

      # Run the rspec
      RSpec::Core::Runner.run([file.path])
      file.unlink
      hash_structure = json_formatter.output_hash

      # Clean up the data: Delete the backtrace if present
      begin
        hash_structure[:examples][0][:exception].delete(:backtrace)
      rescue NoMethodError => e
      end
      collected_results[expectation.id] = hash_structure
    end

    SpecRun.create!(raw_data: collected_results, project: proj, manual: manual)
  end
end

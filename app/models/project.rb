# == Schema Information
#
# Table name: projects
#
#  created_at :datetime
#  id         :integer          not null, primary key
#  name       :string(255)
#  notes      :text
#  updated_at :datetime
#  user_id    :integer
#

require 'tempfile'
require 'rspec'
require 'rspec/core/formatters/json_formatter'

class Project < ActiveRecord::Base
  has_many :apps
  belongs_to :user

  validates :user, presence: true
  default_scope { order('name') }

  def to_rspec
    result = "describe '#{name}' do\n"
    apps.each { |e| result += e.to_rspec.indent(2) }
    result + "end\n"
  end

  def to_plaintext
    result = "Project \"#{name}\":\n"
    apps.each { |e| result += e.to_plaintext.indent(2) }
    result
  end

  def owned_by(user)
    self.user == user
  end

  # Run this project's specs
  def self.perform(project_id: nil, user_id: nil)
    user = User.find(user_id)
    proj = Project.find(project_id)
    if !proj.owned_by(user)
      raise "#{user} isn't authorized to run #{proj}"
    end
    logger.debug("Performing test:\n#{proj.to_rspec}")
    file = Tempfile.new('rspec')
    file.write(proj.to_rspec)
    file.close
     
    # Prepare the rspec runner
    config = RSpec.configuration
    json_formatter = RSpec::Core::Formatters::JsonFormatter.new(config.out)     
    reporter =  RSpec::Core::Reporter.new(json_formatter)
    config.instance_variable_set(:@reporter, reporter)
     
    RSpec::Core::Runner.run([file.path])
    file.unlink
    result = json_formatter.output_hash
  end
end

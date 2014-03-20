# == Schema Information
#
# Table name: expectations
#
#  created_at     :datetime
#  expected       :string(255)
#  id             :integer          not null, primary key
#  matcher_id     :integer          not null
#  project_id     :integer
#  requirement_id :integer          not null
#  subject        :string(255)      not null
#  updated_at     :datetime
#

# Very important: Expectations are immutable. 
# In the future, if we allow users to "edit" an expectation, then
# we must actually create a new instance in the old one's place.
# This immutability allows for many optimizations.
class Expectation < ActiveRecord::Base
  belongs_to :matcher
  belongs_to :requirement
  belongs_to :project
  validates  :project, :matcher, :requirement, :subject, presence: true

  # Set the redundant project attribute automatically
  before_validation(on: :create) do
    self.project = self.requirement.project
  end



  # Following the Law of Demeter:
  def type_icon
    matcher.icon
  end

  def summary
    matcher.summary
  end


  # true  = passed
  # false = failed
  # nil   = not tested
  def passed?
    spec_run = my_spec_run
    return nil if spec_run.nil?
    spec_run.status?(expectation: self)
  end


  def to_s
    "#{subject} should #{matcher} #{expected}"
  end


  def to_rspec
    expected_text = expected.blank? ? '' : "'#{expected}'"
    "expect('#{subject}').to #{matcher.code} #{expected_text}\n"
  end


  def to_plaintext
    "Expectation: " + self.to_s + "\n"
  end


  def to_encapsulated_rspec
    <<-here
require 'rspec/webservice_matchers'

describe 'encapsulated' do
  it 'does this rspec' do
    #{to_rspec.strip}
  end
end
    here
  end


  # Return the message to display for the actual result,
  # vs. the expected response.
  # Is blank if I passed, or if no message is coded for the
  # open source matcher.
  def actual_message
    spec_run = my_spec_run
    return '' if spec_run.nil? # No tests run yet
    
    message = spec_run.exception_message_for(expectation: self)

    # Do some de-geekifying
    message.sub!(/^getaddrinfo: Name or service not known$/, 'Domain name not found')
    message.sub(/^execution expired$/, 'Timed out')
  end


  def code
    matcher.code
  end


  private

  def my_spec_run
    self.requirement.app.project.most_recent_test
  end

end

# == Schema Information
#
# Table name: expectations
#
#  created_at     :datetime
#  expected       :string(255)
#  id             :integer          not null, primary key
#  matcher_id     :integer          not null
#  requirement_id :integer          not null
#  subject        :string(255)      not null
#  updated_at     :datetime
#

class Expectation < ActiveRecord::Base
  belongs_to :requirement
  belongs_to :matcher


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

end

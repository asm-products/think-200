# == Schema Information
#
# Table name: expectations
#
#  created_at     :datetime
#  expectation    :string(255)
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
    "#{subject} should #{matcher} #{expectation}"
  end
end

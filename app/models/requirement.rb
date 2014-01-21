# == Schema Information
#
# Table name: requirements
#
#  app_id     :integer
#  created_at :datetime
#  id         :integer          not null, primary key
#  name       :string(255)
#  notes      :text
#  updated_at :datetime
#

class Requirement < ActiveRecord::Base
  belongs_to :app
  has_many   :expectations
  default_scope { order('name') }

  def to_s
    name
  end

  def to_rspec
    result = "it '#{name}' do\n"
    expectations.each { |e| result += e.to_rspec + "\n" }
    result += "end"
  end
end

# == Schema Information
#
# Table name: apps
#
#  created_at :datetime
#  id         :integer          not null, primary key
#  name       :string(255)
#  notes      :text
#  project_id :integer
#  updated_at :datetime
#

class App < ActiveRecord::Base
  belongs_to :project
  has_many   :requirements, dependent: :destroy

  default_scope { order(:name) }

  def to_rspec
    result = "context '#{name}' do\n"
    requirements.each { |e| result += e.to_rspec.indent(2) }
    result + "end\n"
  end

  def to_plaintext
    result = "App \"#{name}\":\n"
    requirements.each { |e| result += e.to_plaintext.indent(2)}
    result
  end

  def passed?
    return nil if requirements.empty?
    ! requirements.map{|e| e.passed?}.include?(false)
  end
end

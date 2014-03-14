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

  validates :name, presence: true
  validates :project_id, presence: true
  validates :name, uniqueness: { scope: :project_id }

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

  # true  = passed
  # false = failed
  # nil   = untested, at least in part
  def passed?
    # No requirements?
    if requirements.empty?
      return nil
    end

    # A failing requirement?
    results = requirements.map{ |r| r.passed? }
    if results.include?(false)
      return false
    end

    # An untested requirement?
    if results.include?(nil)
      return nil
    end

    true
  end

  def to_s
    name
  end
end

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
  has_many :requirements, through: :apps
  has_many :expectations, through: :requirements
  has_many :spec_runs
  belongs_to :user

  validates :user, presence: true

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

  def owned_by?(user)
    self.user == user
  end

  def passed?
    true
  end

  def most_recent_test
    spec_runs.last
  end
end

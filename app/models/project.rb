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

class Project < ActiveRecord::Base
  has_many :apps
  has_many :requirements, through: :apps
  has_many :expectations, through: :requirements
  has_many :spec_runs
  belongs_to :user

  validates :user, presence: true

  def to_rspec
    result = <<-END.strip_heredoc
      #
      # #{rspec_filename}
      # 
      # Project: #{name}
      # Generated #{Time.now} by Think200.com
      #
      require 'rspec/webservice_matchers'

      describe '#{name}' do
    END
    # apps.each { |e| result += e.to_rspec.indent(2) }
    contexts = apps.map { |a| a.to_rspec.indent(2) }
    result + contexts.join("\n") + "end\n"
  end

  def to_plaintext
    result = "Project \"#{name}\":\n"
    apps.each { |e| result += e.to_plaintext.indent(2) }
    result
  end

  def owned_by?(user)
    self.user == user
  end

  def most_recent_test
    spec_runs.last
  end

  # Returns true, false, or nil.
  def passed?
    if expectations.empty?
      nil
    else
      ! expectations.map{|e| e.passed?}.include?(false)
    end
  end

  def failing_requirements
    requirements
  end

  def rspec_filename
    name.underscore + '_spec.rb'
  end

end

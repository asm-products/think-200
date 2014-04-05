require 'think200_jobs'
require 'think200_libs'
# == Schema Information
#
# Table name: projects
#
#  created_at       :datetime
#  id               :integer          not null, primary key
#  in_progress      :boolean
#  most_recent_test :integer
#  name             :string(255)
#  notes            :text
#  tested_at        :datetime
#  updated_at       :datetime
#  user_id          :integer
#

class Project < ActiveRecord::Base
  has_many :apps, dependent: :destroy
  belongs_to :user

  # Convenience functions
  has_many :requirements, through: :apps
  has_many :expectations
  has_many :spec_runs
  belongs_to :most_recent_test, class_name: 'SpecRun', foreign_key: :most_recent_test

  validates :user, presence: true
  validates_associated :user
  validates :name, presence: true
  validates :name, uniqueness: { scope: :user_id }

  def queue_for_testing
    unless incomplete?
      self[:in_progress] = true
      self.save!
      Resque.enqueue(Think200::ScheduledTest, id, user_id)
    end
  end

  # Do I have rspec to offer?
  # Yes, if I have been saved.
  def rspec?
    persisted?
  end

  def to_rspec
    return nil if name.nil?

    result = <<-END.strip_heredoc
    #
    # #{rspec_filename}
    #
    # To run these tests:
    #   1. Install Ruby >= 2.0.0
    #   2. Install RSpec: $ gem install rspec-webservice_matchers --version 1.4.6
    #   3. Save this code as "#{rspec_filename}"
    #   4. Run RSpec:     $ rspec ./#{rspec_filename}
    #
    # Generated on #{Time.zone.now.to_s(:db)} by think200.com
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

    # nil   = untested, at least in part
    # false = failed, at least in part
    # true  = passed
    def passed?
      return nil   if most_recent_test.nil? || !most_recent_test.covered?(expectation_ids)
      return false if most_recent_test.any_failed?
      return true
    end

    def expectation_ids
      @expectation_ids ||= expectations.pluck(:id)
    end


    # True if not runnable; the user needs to
    # add expectations.
    def incomplete?
      expectation_ids.empty?
    end

    def runnable?
      ! incomplete?
    end

    def tested?
      ! tested_at.nil?
    end

    def failing_requirements
      requirements.select{|r| r.failed?}
    end

    def rspec_filename
      name_slug + '_spec.rb'
    end

    def text_filename
      name_slug + '.txt'
    end

    def to_s
      name
    end


    private
    def name_slug
      name.underscore.gsub(/[\. ]/, '_')
    end

  end

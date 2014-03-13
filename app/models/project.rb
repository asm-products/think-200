# == Schema Information
#
# Table name: projects
#
#  created_at  :datetime
#  id          :integer          not null, primary key
#  in_progress :boolean
#  name        :string(255)
#  notes       :text
#  tested_at   :datetime
#  updated_at  :datetime
#  user_id     :integer
#

class Project < ActiveRecord::Base
  has_many :apps, dependent: :destroy
  belongs_to :user

  # Convenience functions
  has_many :requirements, through: :apps
  has_many :expectations, through: :requirements
  has_many :spec_runs

  validates :user, presence: true
  validates :name, presence: true
  validates :name, uniqueness: { scope: :user_id }


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
    #
    #   1. Install Ruby >= 2.0.0
    #   2. Install RSpec: $ gem install rspec-webservice_matchers
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

    def most_recent_test
      spec_runs.order('created_at DESC').first
    end

    # Returns true, false, or nil.
    def passed?
      if expectations.empty?
        nil
      else
        ! expectations.map{|e| e.passed?}.include?(false)
      end
    end

    # Not runnable; user needs to add expectations.
    def incomplete?
      expectations.empty?
    end

    def tested?
      ! tested_at.nil?
    end

    def test_status_string
      if ! tested?
        'untested'
      elsif passed?
        'passed'
      else
        'failed'
      end
    end

    def failing_requirements
      requirements
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

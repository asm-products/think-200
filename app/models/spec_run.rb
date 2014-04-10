# == Schema Information
#
# Table name: spec_runs
#
#  created_at :datetime
#  id         :integer          not null, primary key
#  manual     :boolean
#  project_id :integer
#  raw_data   :text
#  updated_at :datetime
#
# Indexes
#
#  index_spec_runs_on_project_id  (project_id)
#

class SpecRun < ActiveRecord::Base
  belongs_to :project
  serialize :raw_data, Hash
  validates :raw_data, :project_id, presence: true

  STATUS_FAILED = 'failed'

  SpecResult = Struct.new(:success?, :error_message, :duration)

  # Return a hash of SpecResults, keyed by
  # Expectation id
  def results
    unless @result
      @result = {}
      raw_data.each_pair do |expectation_id, structure|
        status   = (structure[:examples][0][:status] != STATUS_FAILED)
        message  = status ? '' : structure[:examples][0][:exception][:message]
        duration = structure[:summary][:duration]
        @result[expectation_id] = SpecResult.new(status, message, duration)
      end
    end
    @result
  end

  def any_failed?
    results.values.map{|r| r.success? }.include?(false)
  end

  def passed?
    !any_failed?
  end

  def status?(expectation:)
    results[expectation.id].try(:success?)
  end

  def exception_message_for(expectation:)
    results[expectation.id].try(:error_message) || ''
  end

  # True if I've covered these expectations
  def covered?(expectation_ids)
    my_expectation_ids.to_set.superset?(expectation_ids.to_set)
  end

  # Email to notify about events
  def contact_email
    project.user.email
  end


  private

  def my_expectation_ids
    results.keys
  end

end

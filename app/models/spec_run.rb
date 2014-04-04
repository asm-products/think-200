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

  SpecResult = Struct.new("SpecResult", :success?, :error_message, :duration)

  # Return a hash of SpecResults, keyed by
  # Expectation id
  def results
    result = {}
    raw_data.each_pair do |expectation_id, structure|
      status   = (structure[:examples][0][:status] != STATUS_FAILED)
      message  = status ? '' : structure[:examples][0][:exception][:message]
      duration = structure[:summary][:duration]
      result[expectation_id] = SpecResult.new(status, message, duration)
    end
    result
  end

  def passed?
    statuses = raw_data.keys.map{ |k| raw_data[k][:examples][0][:status] }
    !statuses.include? STATUS_FAILED
  end

  def any_failed?
    results.values.map{|r| r.success? }.include?(false)
  end

  # True if I've covered these expectations
  def covered?(expectation_ids)
    my_expectation_ids.to_set.superset?(expectation_ids.to_set)
  end

  def status?(expectation: nil)
    begin
      if raw_data[expectation.id][:examples][0][:status] == STATUS_FAILED
        false
      else
        true
      end
    rescue
      nil
    end
  end

  def exception_message_for(expectation:)
    begin
      raw_data[expectation.id][:examples][0][:exception][:message]
    rescue
      ''
    end
  end


  private

  def my_expectation_ids
    results.keys.sort
  end

end

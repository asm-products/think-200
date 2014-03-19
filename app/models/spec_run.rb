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


  SpecResult = Struct.new(:passed, :error_message, :duration)
  
  # Return a hash of SpecResults, keyed by 
  # Expectation id
  def results
    result = {}
    for e in raw_data.keys
      result[e] = nil
    end
    result
  end


  def passed?
    statuses = raw_data.keys.map{ |k| raw_data[k][:examples][0][:status] }
    !statuses.include? STATUS_FAILED
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
  STATUS_FAILED = 'failed'
end

class SpecRun < ActiveRecord::Base
  belongs_to :project
  serialize :raw_data, Hash
  validates :raw_data, :project_id, presence: true
end

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
end

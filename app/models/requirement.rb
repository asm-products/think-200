# == Schema Information
#
# Table name: requirements
#
#  app_id     :integer
#  created_at :datetime
#  id         :integer          not null, primary key
#  name       :string(255)
#  notes      :text
#  updated_at :datetime
#

class Requirement < ActiveRecord::Base
  belongs_to :app
end

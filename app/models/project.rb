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
  belongs_to :user

  validates :user, presence: true
  default_scope { order('name') }
end

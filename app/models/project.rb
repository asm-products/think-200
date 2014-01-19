class Project < ActiveRecord::Base
  has_many :apps
  belongs_to :user
end

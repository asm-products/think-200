# == Schema Information
#
# Table name: matchers
#
#  code       :string(255)      not null
#  created_at :datetime
#  id         :integer          not null, primary key
#  max_args   :integer          not null
#  min_args   :integer          not null
#  updated_at :datetime
#

class Matcher < ActiveRecord::Base
  has_many :expectations
end

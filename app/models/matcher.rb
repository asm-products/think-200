# == Schema Information
#
# Table name: matchers
#
#  code        :string(255)      not null
#  created_at  :datetime
#  description :text
#  id          :integer          not null, primary key
#  max_args    :integer          not null
#  min_args    :integer          not null
#  summary     :string(255)
#  updated_at  :datetime
#

class Matcher < ActiveRecord::Base
  has_many :expectations
  validates :code, :summary, uniqueness: true
  validates :code, :max_args, :min_args, :summary, :description, presence: true

  def to_s
    code.gsub('_', ' ')
  end
end

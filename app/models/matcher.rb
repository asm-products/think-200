# == Schema Information
#
# Table name: matchers
#
#  code        :string(255)      not null
#  created_at  :datetime
#  description :text
#  icon        :string(255)
#  id          :integer          not null, primary key
#  max_args    :integer          not null
#  min_args    :integer          not null
#  placeholder :string(255)
#  summary     :string(255)
#  updated_at  :datetime
#

class Matcher < ActiveRecord::Base
  has_many :expectations, dependent: :restrict_with_exception

  validates :code, :summary, uniqueness: true
  validates :code, :max_args, :min_args, :summary, :description, presence: true

  def self.for(code)
    Matcher.find_by(code: code)
  end

  def to_s
    code.gsub('_', ' ')
  end

  def summary
    self[:summary].html_safe
  end
end

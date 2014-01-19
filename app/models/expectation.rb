class Expectation < ActiveRecord::Base
  belongs_to :requirement
  belongs_to :matcher
end

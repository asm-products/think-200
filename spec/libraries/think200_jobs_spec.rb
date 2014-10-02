# think200-jobs spec

require 'spec_helper'
require 'think200_jobs'

describe 'Think200 library' do
  describe Think200::STANDARD_QUEUE do
    it { should be_a String }
  end

  describe Think200::ManualTest do
    # it 'runs a test marked "manual"'
  end
end

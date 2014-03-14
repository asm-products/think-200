require 'spec_helper'
require 'think200'

describe Think200 do
  describe 'Think200#aggregate_test_status(collection)' do
    it 'is nil if collection is empty' do
      expect(Think200.aggregate_test_status(collection: [])).to be nil
    end
  end
end

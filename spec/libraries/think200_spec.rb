require 'spec_helper'
require 'think200'

describe Think200 do
  describe 'Think200#aggregate_test_status(collection)' do
    before(:each) do
      @false1 = mock()
      @false1.stub!(:passed?).and_return(false)

      @true1 = mock()
      @true1.stub!(:passed?).and_return(true)
    end

    it 'is nil if the collection is empty' do
      expect(Think200.aggregate_test_status(collection: [])).to be nil
    end

    it 'is false if any of the items returns false for #passed?' do
      expect(Think200.aggregate_test_status(collection: [@false1, @true1])).to be false
    end

    it 'is nil if the collection is a mix of nil and true for #passed?'
    it 'is nil if all the items return nil for #passed?'
    it 'is true if all the items return true for #passed?'
  end
end

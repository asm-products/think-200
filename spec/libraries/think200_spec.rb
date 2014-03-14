require 'spec_helper'
require 'think200'

describe Think200 do
  describe 'Think200#aggregate_test_status(collection)' do

    it 'is nil if the collection is empty' do
      expect(Think200.aggregate_test_status(collection: [])).to be nil
    end

    it 'is false if any of the items returns false for #passed?' do
      expect(Think200.aggregate_test_status(collection: [
        double(:passed? => false), 
        double(:passed? => true),
        double(:passed? => true),
        double(:passed? => true),
        ])).to be false
    end

    it 'is false if #passed? returns all three values' do
      expect(Think200.aggregate_test_status(collection: [
        double(:passed? => false), 
        double(:passed? => true),
        double(:passed? => nil),
        double(:passed? => true),
        ])).to be false
    end

    it 'is nil if the collection is a mix of nil and true for #passed?' do
      expect(Think200.aggregate_test_status(collection: [
        double(:passed? => true), 
        double(:passed? => nil),
        double(:passed? => true), 
        double(:passed? => nil),
        ])).to be nil
    end

    it 'is nil if all the items return nil for #passed?' do
      expect(Think200.aggregate_test_status(collection: [
        double(:passed? => nil),
        double(:passed? => nil),
        double(:passed? => nil),
        double(:passed? => nil),
        double(:passed? => nil),
        ])).to be nil      
    end

    it 'is true if all the items return true for #passed?' do
      expect(Think200.aggregate_test_status(collection: [
        double(:passed? => true), 
        double(:passed? => true),
        double(:passed? => true),
        double(:passed? => true),
        ])).to be true
    end
  end
end

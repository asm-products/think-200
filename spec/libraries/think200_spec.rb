require 'spec_helper'
require 'think200_libs'

describe Think200 do

  describe '#compute_percent_complete' do
    it 'scores zero projects as 100%' do
      expect(Think200.compute_percent_complete({})).to eq 100
    end

    it 'scores all queued as 0%' do
      info = {
        1 => {
          'queued'    => 'true',
          'tested_at' =>  1
         },
        2 => {
          'queued'    => 'true',
          'tested_at' =>  2
         },
        3 => {
          'queued'    => 'true',
          'tested_at' =>  3
         }
      }
      expect( Think200.compute_percent_complete(info) ).to eq 0
    end

    it 'scores 3/4 queued as 25%' do
      info = {
        1 => {
          'queued'    => 'true',
          'tested_at' =>  1
         },
        2 => {
          'queued'    => 'true',
          'tested_at' =>  2
         },
        3 => {
          'queued'    => 'false',
          'tested_at' =>  3
         },
        4 => {
          'queued'    => 'true',
          'tested_at' =>  4
         }
      }
      expect( Think200.compute_percent_complete(info) ).to eq 25
    end
  end


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

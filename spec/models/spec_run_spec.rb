# == Schema Information
#
# Table name: spec_runs
#
#  created_at :datetime
#  id         :integer          not null, primary key
#  manual     :boolean
#  project_id :integer
#  raw_data   :text
#  updated_at :datetime
#
# Indexes
#
#  index_spec_runs_on_project_id  (project_id)
#

require 'spec_helper'

describe SpecRun do
  let(:all_passed) { Fabricate.build(:spec_run_all_passed) }
  let(:all_failed) { Fabricate.build(:spec_run_all_failed) }

  describe '#results' do
    it 'returns keys with Expectation ids' do
      expect(all_passed.results.keys.sort).to eq [111, 222, 333]
    end

    it 'notifies when a test passed' do
      a_result = all_passed.results.values.first
      expect(a_result.success?).to be true
    end

    it 'notifies when a test failed' do
      a_result = all_failed.results.values.first
      expect(a_result.success?).to be false
    end
  end

  describe '#covered?' do
    subject { all_passed } # Tested 111, 222, and 333
    specify { should be_covered([111, 222]) }
    specify { should be_covered([111, 222, 333]) }
    specify { should_not be_covered([111, 222, 999]) }
    specify { should_not be_covered([888, 999]) }
  end

  describe '#any_failed?' do
    it 'is true if all tests failed' do
      expect( all_failed.any_failed? ).to be true
    end

    it 'is false if all tests passed' do
      expect(all_passed.any_failed?).to be false
    end

    it 'is true if some tests passed and some failed' do
      expect(Fabricate.build(:spec_run_mixed_results).any_failed?).to be true
    end
  end

  describe '#passed?' do
    it 'is true when all tests passed' do
      expect(all_passed.passed?).to be true
    end

    it 'is false if any test failed' do
      expect(Fabricate.build(:spec_run_mixed_results).passed?).to be false
    end
  end

  describe '#exception_message_for' do
    it 'returns something when the exectation failed' do
      e = Fabricate.build(:expectation, id: 888)
      expect( all_failed.exception_message_for(expectation: e).length ).to be > 1
    end

    it 'returns a blank string when the expectation passed' do
      e = Fabricate.build(:expectation, id: 222)
      expect( all_passed.exception_message_for(expectation: e).length ).to eql(0)
    end

    it 'returns a blank string when the expectation was not tested' do
      e = Fabricate.build(:expectation, id: 1111111)
      expect( all_passed.exception_message_for(expectation: e).length ).to eql(0)
    end
  end

  describe '#status?' do
    it "returns true if the expectation was tested and passed" do
      expect( all_passed.status? expectation: Fabricate.build(:expectation, id: 111) ).to be true
    end

    it "returns false if the expectation was tested and failed" do
      expect( all_failed.status? expectation: Fabricate.build(:expectation, id: 888) ).to be false
    end

    it "returns nil if the expectation was not tested" do
      expect( all_passed.status? expectation: Fabricate.build(:expectation, id: 999999) ).to be_nil
    end
  end
end

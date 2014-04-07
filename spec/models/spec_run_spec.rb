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
  describe '#results' do
    it 'returns keys with Expectation ids' do
      expect(Fabricate.build(:spec_run_all_passed).results.keys.sort).to eq [111, 222, 333]
    end

    it 'notifies when a test passed' do
      a_result = Fabricate.build(:spec_run_all_passed).results.values.first
      expect(a_result.success?).to be_true
    end

    it 'notifies when a test failed' do
      a_result = Fabricate.build(:spec_run_all_failed).results.values.first
      expect(a_result.success?).to be_false
    end
  end

  describe '#covered?' do
    subject { Fabricate.build(:spec_run_all_passed) } # Tested 111, 222, and 333
    specify { should be_covered([111, 222]) }
    specify { should be_covered([111, 222, 333]) }
    specify { should_not be_covered([111, 222, 999]) }
    specify { should_not be_covered([888, 999]) }
  end

  describe '#any_failed?' do
    it 'is true if all tests failed' do
      expect( Fabricate.build(:spec_run_all_failed).any_failed? ).to be_true
    end

    it 'is false if all tests passed' do
      Fabricate.build(:spec_run_all_passed).any_failed?.should be_false
    end

    it 'is true if some tests passed and some failed' do
      Fabricate.build(:spec_run_mixed_results).any_failed?.should be_true
    end
  end

  describe '#status?' do
    it "returns true if the expectation was tested and passed" do
      spec_run = Fabricate.build(:spec_run_all_passed)
      expect( spec_run.status? expectation: Fabricate.build(:expectation, id: 111) ).to be_true
    end

    it "returns false if the expectation was tested and failed" do
      spec_run = Fabricate.build(:spec_run_all_failed)
      expect( spec_run.status? expectation: Fabricate.build(:expectation, id: 888) ).to be_false
      expect( spec_run.status? expectation: Fabricate.build(:expectation, id: 888) ).to_not be_nil
    end

    it "returns nil if the expectation was not tested" do
      spec_run = Fabricate.build(:spec_run_all_passed)
      expect( spec_run.status? expectation: Fabricate.build(:expectation, id: 999999) ).to be_nil
    end
  end
end

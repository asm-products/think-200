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
    let(:test) { Fabricate.build(:spec_run_all_passed) }

    it 'is true when the ids are a subset' do
      expect(test.covered? [111, 222]).to be_true
    end

    it 'is true when the ids are equal' do
      expect(test.covered? [111, 222, 333]).to be_true
    end

    it 'is false when an id was not tested' do
      expect(test.covered? [111, 121, 222]).to be_false
    end

    it 'is false when none of the ids were tested' do
      expect(test.covered? [8, 9, 10]).to be_false
    end
  end
end

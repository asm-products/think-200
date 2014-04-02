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

  describe '#expectation_ids' do
    it 'returns the tested expectation ids' do
      expect(Fabricate.build(:spec_run_all_passed).expectation_ids).to eq [111, 222, 333]
      expect(Fabricate.build(:spec_run_all_failed).expectation_ids).to eq [888]
    end
  end
end

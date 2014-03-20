require 'spec_helper'

describe SpecRun do  
  describe '#results' do
    it 'returns keys with Expectation ids' do
      expect(Fabricate(:spec_run_all_passed).results.keys.sort).to eq [111, 222, 333]
    end

    it 'notifies when a test passed' do
      a_result = Fabricate(:spec_run_all_passed).results.values.first
      expect(a_result.success?).to be_true
    end

    it 'notifies when a test failed' do
      a_result = Fabricate(:spec_run_all_failed).results.values.first
      expect(a_result.success?).to be_false
    end
  end

  describe '#expectation_ids' do
    it 'returns the tested expectation ids' do
      expect(Fabricate(:spec_run_all_passed).expectation_ids).to eq [111, 222, 333]
      expect(Fabricate(:spec_run_all_failed).expectation_ids).to eq [888]
    end
  end
end

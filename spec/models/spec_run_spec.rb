require 'spec_helper'

describe SpecRun do
  let(:phoebe)  { User.create!(username: 'Phoebe', email: 'phoebe@att.com', password: 'password') }
  let(:att)     { Project.create!(name: "Client - AT&T", user: phoebe) }
  let(:all_passing) { SpecRun.create!(project: att, raw_data:
                                      {
                                        3=>
                                        {
                                          :examples=>
                                          [{:description=>"does this rspec",
                                             :full_description=>"encapsulated does this rspec",
                                             :status=>"passed",
                                             :file_path=>"/tmp/rspec20140316-17211-1u2gd68",
                                             :line_number=>4}],
                                          :summary=>
                                          {
                                            :duration=>0.024736337,
                                            :example_count=>1,
                                            :failure_count=>0,
                                            :pending_count=>0
                                          },
                                          :summary_line=>"1 example, 0 failures"},
                                        
                                        1=>
                                        {
                                          :examples=>
                                          [{:description=>"does this rspec",
                                             :full_description=>"encapsulated does this rspec",
                                             :status=>"passed",
                                             :file_path=>"/tmp/rspec20140316-17211-1lxntyb",
                                             :line_number=>4}],
                                          :summary=>
                                          {
                                            :duration=>0.241699992,
                                            :example_count=>1,
                                            :failure_count=>0,
                                            :pending_count=>0
                                          },
                                          :summary_line=>"1 example, 0 failures"
                                        },

                                        2=>
                                        {:examples=>
                                          [{:description=>"does this rspec",
                                             :full_description=>"encapsulated does this rspec",
                                             :status=>"passed",
                                             :file_path=>"/tmp/rspec20140316-17211-lja33o",
                                             :line_number=>4}],
                                          :summary=>
                                          {:duration=>0.013908195,
                                            :example_count=>1,
                                            :failure_count=>0,
                                            :pending_count=>0},
                                          :summary_line=>"1 example, 0 failures"}
                                      }                                        
                                      )}
  
  describe '#results' do
    it 'returns keys with Expectation ids' do
      expect(all_passing.results.keys.sort).to eq [1, 2, 3]
    end

    it 'notifies when a test passed' do
      a_result = all_passing.results.values.first
      expect(a_result.success?).to be_true
    end

    it 'notifies when a test failed' do
      a_result = Fabricate(:spec_run_all_failed).results.values.first
      expect(a_result.success?).to be_false
    end
  end

  describe '#expectation_ids' do
    it 'returns the tested expectations' do
      expect(all_passing.expectation_ids).to eq [1, 2, 3]
      expect(Fabricate(:spec_run_all_failed).expectation_ids).to eq [8]
    end
  end
end

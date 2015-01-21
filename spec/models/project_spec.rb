# == Schema Information
#
# Table name: projects
#
#  created_at       :datetime
#  id               :integer          not null, primary key
#  in_progress      :boolean
#  most_recent_test :integer
#  name             :string(255)
#  notes            :text
#  tested_at        :datetime
#  updated_at       :datetime
#  user_id          :integer
#

require 'spec_helper'

describe Project do
  before(:each) do
    @proj      = Fabricate(:project)
    @api       = Fabricate(:app, project: @proj)
    @is_online = Fabricate(:requirement, app: @api)
  end

  describe '#passed?' do
    it "is nil when the project is not finished" do
      proj = Fabricate(:project)
      expect(proj.passed?).to be nil

      api = Fabricate(:app, project: proj)
      expect(proj.passed?).to be nil

      is_online = Fabricate(:requirement, app: api)
      expect(proj.passed?).to be nil
    end

    it "is nil when the project's expectations are all untested" do
      (1..5).each { Fabricate(:expectation, requirement: @is_online) }
      # Not creating any spec runs
      expect(@proj.passed?).to be nil
    end

    it 'is false if all tests failed' do
      Fabricate(:expectation, id: 888, requirement: @is_online)
      Fabricate(:spec_run_all_failed, project: @proj)
      @proj.passed?.should be false
    end

    it 'is false if the tests are a mix of pass and fail' do
      [111, 222, 333, 888].each { |n| Fabricate(:expectation, id: n, requirement: @is_online) }
      Fabricate(:spec_run_mixed_results, project: @proj)
      @proj.passed?.should be false
    end

    it 'is nil if the tests are a mix of pass and fail, and untested expectations' do
      [111, 222, 333, 444, 888].each { |n| Fabricate(:expectation, id: n, requirement: @is_online) }
      # Intentionally untested: No SpecRun data for #444 in models.rb
      Fabricate(:spec_run_mixed_results, project: @proj)
      @proj.passed?.should be_nil
    end

    it 'is true when all expectations have been tested and passed' do
      [111, 222, 333].each { |n| Fabricate(:expectation, id: n, requirement: @is_online) }
      Fabricate(:spec_run_all_passed, project: @proj)
      @proj.passed?.should be_truthy
    end

    it 'is nil when all tested expectations have passed but some are untested' do
      [111, 222, 333, 444].each { |n| Fabricate(:expectation, id: n, requirement: @is_online) }
      Fabricate(:spec_run_all_passed, project: @proj)
      @proj.passed?.should be_nil
    end
  end


  describe '#failing_expectations' do
    it 'is empty if the project is untested' do
      project = Fabricate(:project)
      expect( project.failing_expectations ).to be_empty
    end

    it 'returns the correct expectations' do
      [111, 222, 333, 888].each { |n| Fabricate(:expectation, id: n, requirement: @is_online) }
      Fabricate(:spec_run_mixed_results, project: @proj)
      @proj.failing_expectations.should eq [Expectation.find(888)]
    end
  end


  describe "#invalid?" do
    it 'when the user is missing' do
      Project.create(name: 'New Web Startup').should be_invalid
    end

    it 'when the user is present but invalid' do
      invalid_user = User.create(username: 'Name With Spaces', email: 'me@app.com', password: 'pass')
      proj         = Project.create(name: 'New iOS app', user: invalid_user)
      expect(proj).to be_invalid
      expect(proj.errors[:user]).to include('is invalid')
    end
  end


  describe '#most_recent_test' do
    it 'is nil if the project is untested' do
      project = Fabricate(:project)
      expect( project.most_recent_test ).to be_nil
    end

    it 'returns the last spec_run' do
      Fabricate(:expectation, id: 888, requirement: @is_online)

      spec_run_1  = Fabricate(:spec_run_all_failed, project: @proj)
      spec_run_2  = Fabricate(:spec_run_all_failed, project: @proj)
      spec_run_3  = Fabricate(:spec_run_all_failed, project: @proj)

      expect( @proj.most_recent_test ).to eq spec_run_3
    end
  end
end

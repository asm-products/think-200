# == Schema Information
#
# Table name: projects
#
#  created_at  :datetime
#  id          :integer          not null, primary key
#  in_progress :boolean
#  name        :string(255)
#  notes       :text
#  tested_at   :datetime
#  updated_at  :datetime
#  user_id     :integer
#

require 'spec_helper'

describe Project do
  describe '#passed?' do
    it "is nil when the project is not finished" do
      proj = Fabricate.build(:project)
      expect(proj.passed?).to be nil

      api = Fabricate.build(:app, project: proj)
      expect(proj.passed?).to be nil

      is_online = Fabricate.build(:requirement, app: api)
      expect(proj.passed?).to be nil
    end

    it "is nil when the project's expecations are all untested" do
      proj      = Fabricate.build(:project)
      api       = Fabricate.build(:app, project: proj)
      is_online = Fabricate.build(:requirement, app: api)
      (1..5).each { Fabricate.build(:expectation, requirement: is_online) }
      # No spec runs
      expect(proj.passed?).to be nil
    end

    it 'is false if all tests failed' do
      proj        = Fabricate(:project)
      api         = Fabricate(:app, project: proj)
      is_online   = Fabricate(:requirement, app: api)
      expectation = Fabricate(:expectation, id: 888, requirement: is_online)
      spec_run    = Fabricate(:spec_run_all_failed, project: proj)

      proj.passed?.should be_false
      proj.passed?.should_not be_nil
    end

    it 'is false if the tests are a mix of pass and fail' do
      proj      = Fabricate(:project)
      api       = Fabricate(:app, project: proj)
      is_online = Fabricate(:requirement, app: api)
      [111, 222, 333, 888].each { |n| Fabricate(:expectation, id: n, requirement: is_online) }
      spec_run = Fabricate(:spec_run_mixed_results, project: proj)
      proj.passed?.should be_false
      proj.passed?.should_not be_nil
    end

    it 'is false if the tests are a mix of pass and fail, and untested expectations' do
      proj      = Fabricate(:project)
      api       = Fabricate(:app, project: proj)
      is_online = Fabricate(:requirement, app: api)
      [111, 222, 333, 888].each { |n| Fabricate(:expectation, id: n, requirement: is_online) }
      # Untested: No SpecRun data for it in models.rb
      Fabricate(:expectation, id: 444, requirement: is_online)
      spec_run = Fabricate(:spec_run_mixed_results, project: proj)

      proj.passed?.should be_false
      proj.passed?.should_not be_nil
    end

    it 'is true when all expectations have been tested and passed' do
      proj      = Fabricate.build(:project, id: (rand * 1000000).to_i)
      api       = Fabricate.build(:app, project: proj)
      is_online = Fabricate.build(:requirement, app: api)
      [111, 222, 333].each { |n| Fabricate.build(:expectation, id: n, requirement: is_online) }
      spec_run = Fabricate(:spec_run_all_passed, project: proj)

      proj.passed?.should be_true
    end

    it 'is nil when all tested expectations have passed but some are untested' do
      proj      = Fabricate.build(:project)
      api       = Fabricate.build(:app, project: proj)
      is_online = Fabricate.build(:requirement, app: api)
      [111, 222, 333].each { |n| Fabricate.build(:expectation, id: n, requirement: is_online) }
      # Untested: No SpecRun data for it in models.rb
      Fabricate.build(:expectation, id: 444, requirement: is_online)
      spec_run = Fabricate.build(:spec_run_all_passed, project: proj)

      proj.passed?.should be_nil
    end
  end


  describe "#invalid?" do
    it 'when the user is missing' do
      proj = Project.create(name: 'LiquidSunshine.com')
      expect(proj).to be_invalid
    end

    it 'when the user is present but invalid' do
      invalid_user = User.create(username: 'Name With Spaces', email: 'valid@email.com', password: 'sekret')
      proj = Project.create(name: 'LiquidSunshine.com', user: invalid_user)
      expect(proj).to be_invalid
      expect(proj.errors[:user]).to include('is invalid')
    end
  end

  describe '#most_recent_test' do
    it 'is nil if the project is untested' do
      project = Fabricate.build(:project)
      expect(project.most_recent_test).to be_nil
    end

    it 'returns the last spec_run' do
      project     = Fabricate(:project)
      api         = Fabricate(:app, project: project)
      is_online   = Fabricate(:requirement, app: api)
      expectation = Fabricate(:expectation, id: 888, requirement: is_online)

      spec_run_1  = Fabricate(:spec_run_all_failed, project: project)
      spec_run_2  = Fabricate(:spec_run_all_failed, project: project)
      spec_run_3  = Fabricate(:spec_run_all_failed, project: project)

      expect(project.most_recent_test).to eq spec_run_3
    end
  end
end

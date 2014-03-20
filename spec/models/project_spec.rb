require 'spec_helper'

describe Project do
  describe '#passed?' do
    it "is nil when the project is not finished" do
      proj = Fabricate(:project)
      expect(proj.passed?).to be nil

      api = Fabricate(:app, project: proj)
      expect(proj.passed?).to be nil

      is_online = Fabricate(:requirement, app: api)
      expect(proj.passed?).to be nil
    end

    it "is nil when the project's expecations are all untested" do
      proj      = Fabricate(:project)
      api       = Fabricate(:app, project: proj)
      is_online = Fabricate(:requirement, app: api)
      (1..5).each { Fabricate(:expectation, requirement: is_online) }
      # No spec runs
      expect(proj.passed?).to be nil
    end

    it 'is false if all tests failed' do
      proj      = Fabricate(:project)
      api       = Fabricate(:app, project: proj)
      is_online = Fabricate(:requirement, app: api)
      Fabricate(:expectation, id: 888, requirement: is_online)
      spec_run = Fabricate(:spec_run_all_failed)

      proj.passed?.should be_false
    end

    it 'is false if the tests are a mix of pass and fail' do
      proj      = Fabricate(:project)
      api       = Fabricate(:app, project: proj)
      is_online = Fabricate(:requirement, app: api)
      [111, 222, 333, 888].each { |n| Fabricate(:expectation, id: n, requirement: is_online) }
      spec_run = Fabricate(:spec_run_mixed_results)

      proj.passed?.should be_false
    end

    it 'is true when all expectations have been tested and passed'
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
end

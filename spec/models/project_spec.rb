require 'spec_helper'

describe Project do
  let(:phoebe) { Fabricate(:user) }

  describe '#passed?' do
    it "is nil when the project is not finished" do
      proj = Project.create!(name: "Client - AT&T", user: phoebe)
      expect(proj.passed?).to be nil

      api = App.create!(name: 'API', project: proj)
      expect(proj.passed?).to be nil

      is_online = Requirement.create!(name: 'is online', app: api)
      expect(proj.passed?).to be nil
    end

    it "is nil when the project's expecations are all untested" do
      proj = Project.create!(name: "Client - AT&T", user: phoebe)
      api = App.create!(name: 'API', project: proj)
      is_online = Requirement.create!(name: 'is online', app: api)
      Expectation.create!(
        subject:     'att.com',
        matcher:     Matcher.find_by_code('redirect_permanently_to'),
        expected:    'att.com/',
        requirement: is_online
      )
      Expectation.create!(
        subject:     'sprint.com',
        matcher:     Matcher.find_by_code('redirect_permanently_to'),
        expected:    'www.sprint.com',
        requirement: is_online
      )
      expect(proj.passed?).to be nil
    end

    it 'is true when all expectations have been tested and passed' 
    it 'is false if any expectation failed a test'
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

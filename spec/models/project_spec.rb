require 'spec_helper'

describe Project do
  let(:phoebe) {User.create!(username: 'Phoebe', email: 'phoebe@att.com', password: 'password')}

  describe '#passed?' do
    it "is nil when the project is not finished or is untested" do
      proj = Project.create!(name: "Client - AT&T", user: phoebe)
      expect(proj.passed?).to be nil

      api = App.create!(name: 'API', project: proj)
      expect(proj.passed?).to be nil

      is_online = Requirement.create!(name: 'is online', app: api)
      expect(proj.passed?).to be nil

      redirect1 = Expectation.create!(
        subject:     'att.com',
        matcher:     Matcher.find_by_code('redirect_permanently_to'),
        expected:    'att.com/',
        requirement: is_online
      )
      expect(proj.passed?).to be nil
    end
  end
end

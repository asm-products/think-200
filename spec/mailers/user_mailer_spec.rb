require "spec_helper"

describe UserMailer do
  describe "#test_failed" do
    before(:each) do
      @proj       = Fabricate.build(:project)
      api         = Fabricate.build(:app, project: @proj)
      is_online   = Fabricate.build(:requirement, app: api)
      expectation = Fabricate.build(:expectation, id: 888, requirement: is_online)
      spec_run    = Fabricate.build(:spec_run_all_failed, project: @proj)

      @proj.tested_at        = Time.now
      @proj.in_progress      = false
      @proj.most_recent_test = spec_run
      @mail = UserMailer.test_failed(spec_run)
    end

    it "renders the headers" do
      @mail.subject.should match(/failed/i)
      @mail.to.should      eq([@proj.user.email])
      @mail.from.should    eq([CONTACT_EMAIL_SHORT])
    end

    it "renders the body" do
      @mail.body.encoded.should match(/failed/i)
    end

    it 'sends an email' do
      @mail.deliver
      ActionMailer::Base.deliveries.should_not be_empty
    end
  end

  describe "#test_is_passing" do
    before (:each) do
      proj        = Fabricate.build(:project)
      api         = Fabricate.build(:app, project: proj)
      is_online   = Fabricate.build(:requirement, app: api)
      expectation = Fabricate.build(:expectation, id: 111, requirement: is_online)
      spec_run    = Fabricate.build(:spec_run_all_passed, project: proj)
      proj.tested_at        = Time.now
      proj.in_progress      = false
      proj.most_recent_test = spec_run
      @mail = UserMailer.test_is_passing(spec_run)
      @user = proj.user
    end

    it "renders the headers" do
      @mail.subject.should match(/passing/i)
      @mail.to.should   eq([@user.email])
      @mail.from.should eq([CONTACT_EMAIL_SHORT])
    end

    it "renders the body" do
      @mail.body.encoded.should match(/passing/i)
    end

    it 'sends an email' do
      @mail.deliver
      ActionMailer::Base.deliveries.should_not be_empty
    end
  end

end

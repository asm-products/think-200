require "spec_helper"

describe UserMailer do

  context 'when a test only succeeds' do
    it 'does not send an email' do
      @proj       = Fabricate(:project)
      api         = Fabricate(:app, project: @proj)
      is_online   = Fabricate(:requirement, app: api)

      # A passing test
      expectation = Fabricate(:expectation, id: 111, requirement: is_online)
      Fabricate(:spec_run_all_passed, project: @proj)
      the_time    = Time.now
      ActionMailer::Base.deliveries.should be_empty

      # Another passing test
      Timecop.freeze(the_time + 1.minute)
      Fabricate(:spec_run_all_passed, project: @proj)
      ActionMailer::Base.deliveries.should be_empty

      Timecop.return
    end
  end


  context 'when a test fails,' do
    it 'an email gets sent' do
      @proj       = Fabricate(:project)
      api         = Fabricate(:app, project: @proj)
      is_online   = Fabricate(:requirement, app: api)

      # First, a passing test
      the_time = Time.now
      Fabricate(:expectation, id: 111, requirement: is_online)
      Fabricate(:spec_run_all_passed, project: @proj)
      ActionMailer::Base.deliveries.should be_empty

      # Now, another passing test
      Timecop.freeze(the_time + 1.minute)
      Fabricate(:spec_run_all_passed, project: @proj)
      ActionMailer::Base.deliveries.should be_empty

      # Now, a failing test
      Timecop.freeze(the_time + 2.minutes)
      Fabricate(:expectation, id: 888, requirement: is_online)
      Fabricate(:spec_run_all_failed, project: @proj)
      ActionMailer::Base.deliveries.should_not be_empty

      Timecop.return
    end
  end


  describe "#test_failed" do
    before(:each) do
      @proj       = Fabricate(:project)
      api         = Fabricate(:app, project: @proj)
      is_online   = Fabricate(:requirement, app: api)
      expectation = Fabricate(:expectation, id: 888, requirement: is_online)
      spec_run    = Fabricate(:spec_run_all_failed, project: @proj)

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
      proj        = Fabricate(:project)
      api         = Fabricate(:app, project: proj)
      is_online   = Fabricate(:requirement, app: api)
      expectation = Fabricate(:expectation, id: 111, requirement: is_online)
      spec_run    = Fabricate(:spec_run_all_passed, project: proj)
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

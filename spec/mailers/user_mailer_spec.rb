require "spec_helper"

describe UserMailer do

  context 'when a test succeeds repeatedly' do
    it 'no email is sent' do
      @proj       = Fabricate(:project)
      api         = Fabricate(:app, project: @proj)
      is_online   = Fabricate(:requirement, app: api)
      expectation = Fabricate(:expectation, id: 111, requirement: is_online)

      # A passing test
      Fabricate(:spec_run_all_passed, project: @proj)

      # Another passing test
      Timecop.freeze(Date.today + 1.minute) do
        Fabricate(:spec_run_all_passed, project: @proj)
      end
      
      ActionMailer::Base.deliveries.should be_empty
    end
  end


  context 'when a test fails after a previous pass,' do
    it 'an email gets sent' do
      @proj       = Fabricate(:project)
      api         = Fabricate(:app, project: @proj)
      is_online   = Fabricate(:requirement, app: api)
      Fabricate(:expectation, id: 111, requirement: is_online)
      Fabricate(:expectation, id: 888, requirement: is_online)

      # First, a passing test
      Fabricate(:spec_run_all_passed, project: @proj)

      # Now, a failing test
      Timecop.freeze(Time.now + 2.minutes) do
        Fabricate(:spec_run_all_failed, project: @proj)
      end

      ActionMailer::Base.deliveries.should_not be_empty
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

require "spec_helper"

describe UserMailer do
  let(:fail_text) { 'failing' }
  let(:pass_text) { 'passing' }

  before(:all) do
    @proj     = Fabricate(:project)
    api       = Fabricate(:app, project: @proj)
    @is_online = Fabricate(:requirement, app: api)
    Fabricate(:expectation, id: 111, requirement: @is_online)
    Fabricate(:expectation, id: 888, requirement: @is_online)
  end

  after(:each) do
    @proj.most_recent_test = nil
  end

  after(:all) do
    Expectation.destroy_all
  end


  describe 'sends' do
    context 'when a test succeeds repeatedly' do
      it 'no email is sent' do
        # A passing test
        Fabricate(:spec_run_all_passed, project: @proj)

        # Another passing test
        Timecop.freeze(Date.today + 1.minute) do
          Fabricate(:spec_run_all_passed, project: @proj)
        end

        ActionMailer::Base.deliveries.should be_empty
      end
    end

    context 'when a test fails repeatedly' do
      it 'no email is sent' do
        ActionMailer::Base.deliveries.should be_empty

        # A failing test
        Fabricate(:spec_run_all_failed, project: @proj)

        # More failing tests
        Timecop.freeze(Date.today + 1.minute) do
          Fabricate(:spec_run_all_failed, project: @proj)
        end

        Timecop.freeze(Date.today + 2.minutes) do
          Fabricate(:spec_run_all_failed, project: @proj)
        end

        ActionMailer::Base.deliveries.should be_empty
      end
    end

    context 'when a test fails after a previous pass,' do
      it 'an email gets sent' do
        # First, a passing test
        Fabricate(:spec_run_all_passed, project: @proj)

        # Now, a failing test
        Timecop.freeze(Time.now + 2.minutes) do
          Fabricate(:spec_run_all_failed, project: @proj)
        end

        ActionMailer::Base.deliveries[0].subject.should match(/#{fail_text}/i)
      end
    end

    context 'when a test passes after a previous fail,' do
      it 'an email gets sent' do
        # First, a failing test
        Fabricate(:spec_run_all_failed, project: @proj)

        # Now, a passing test
        Timecop.freeze(Time.now + 2.minutes) do
          Fabricate(:spec_run_all_passed, project: @proj)
        end

        ActionMailer::Base.deliveries[0].subject.should match(/#{pass_text}/i)
      end
    end
  end


  describe "#test_failed" do
    before(:each) do
      @mail = UserMailer.test_failed(Fabricate(:spec_run_all_failed, project: @proj))
    end

    it "renders the headers" do
      @mail.subject.should include(fail_text, 'requirement')
      @mail.to.should      eq([@proj.user.email])
      @mail.from.should    eq([CONTACT_EMAIL_SHORT])
    end

    it "renders all the necessary information in the body" do
      body = @mail.body.encoded
      reqs = @proj.failing_requirements.map(&:to_s)
      apps = @proj.failing_apps.map(&:to_s)

      body.should include(@proj.name, project_url(@proj), *apps, *reqs)
    end

    it 'sends an email' do
      @mail.deliver
      ActionMailer::Base.deliveries.should_not be_empty
    end
  end


  describe "#test_is_passing" do
    before (:each) do
      @mail = UserMailer.test_is_passing(Fabricate(:spec_run_all_passed, project: @proj))
    end

    it "renders the headers" do
      @mail.subject.should match(/#{pass_text}/i)
      @mail.to.should   eq([@proj.user.email])
      @mail.from.should eq([CONTACT_EMAIL_SHORT])
    end

    it "renders all the necessary information in the body" do
      body = @mail.body.encoded
      body.should include(@proj.name, pass_text, project_url(@proj))
    end

    it 'sends an email' do
      @mail.deliver
      ActionMailer::Base.deliveries.should_not be_empty
    end
  end

end

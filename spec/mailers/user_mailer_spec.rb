require "spec_helper"

describe UserMailer do
  describe "test_failed" do
    it "renders the headers" do
      proj        = Fabricate.build(:project)
      api         = Fabricate.build(:app, project: proj)
      is_online   = Fabricate.build(:requirement, app: api)
      expectation = Fabricate.build(:expectation, id: 888, requirement: is_online)
      spec_run    = Fabricate.build(:spec_run_all_failed, project: proj)

      proj.tested_at        = Time.now
      proj.in_progress      = false
      proj.most_recent_test = spec_run
      mail = UserMailer.test_failed(spec_run)

      mail.subject.should eq("Test failed")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq([CONTACT_EMAIL_SHORT])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

  describe "test_passed" do
    let(:mail) { UserMailer.test_passed }

    it "renders the headers" do
      mail.subject.should eq("Test passed")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq([CONTACT_EMAIL_SHORT])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end

    it 'sends an email' do
      mail.deliver
      ActionMailer::Base.deliveries.should_not be_empty
    end
  end

end


# require 'spec_helper'

# describe UserMailer do
#   describe '#failure_notification' do
#     it 'sends an email' do
#       email = UserMailer.test_failed(
#         error_message = 'Domain name not found',
#         expected      = "#{Faker::Internet.url} should be up",
#         recipient     = Faker::Internet.email,
#         url           = Faker::Internet.url,
#       ).deliver
#       ActionMailer::Base.deliveries.should_not be_empty
#     end

#     it 'renders the subject'
    
#     it 'renders the receiver email'
#   end
# end

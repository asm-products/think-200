require 'spec_helper'

describe UserMailer do
  describe '#failure_notification' do
    it 'sends an email' do
      email = UserMailer.create_failure_notification(
        error_message = 'Domain name not found',
        expected      = "#{Faker::Internet.url} should be up",
        recipient     = Faker::Internet.email,
        url           = Faker::Internet.url,
      ).deliver
      ActionMailer::Base.deliveries.should_not be_empty
    end

    it 'renders the subject'
    
    it 'renders the receiver email'
  end
end

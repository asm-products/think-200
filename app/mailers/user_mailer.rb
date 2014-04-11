class UserMailer < ActionMailer::Base
  default from: CONTACT_EMAIL

  # Send email about this test.
  def self.notify_for(spec_run)
    if spec_run.passed?
      UserMailer.test_is_passing(spec_run).deliver
    else
      UserMailer.test_failed(spec_run).deliver
    end
  end

  def test_failed(spec_run)
    @greeting = "Hi"
    mail to: spec_run.contact_email
  end

  def test_is_passing(spec_run)
    @greeting = "Hi"
    mail to: spec_run.contact_email
  end
end

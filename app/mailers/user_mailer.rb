class UserMailer < ActionMailer::Base
  default from: CONTACT_EMAIL

  def test_failed(spec_run)
    @greeting = "Hi"
    mail to: spec_run.contact_email
  end

  def test_is_passing(spec_run)
    @greeting = "Hi"
    mail to: spec_run.contact_email
  end
end

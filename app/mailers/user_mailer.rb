class UserMailer < ActionMailer::Base
  default from: CONTACT_EMAIL

  def test_failed
    @greeting = "Hi"
    mail to: "to@example.org"
  end

  def test_passed
    @greeting = "Hi"
    mail to: "to@example.org"
  end
end

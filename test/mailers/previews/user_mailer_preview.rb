class UserMailerPreview < ActionMailer::Preview
  def test_failed
    failed_test = nil
    SpecRun.all.each do |s|
      failed_test = s if s.any_failed?
    end
    UserMailer.test_failed(failed_test)
  end

  def test_is_passing
    test = nil
    SpecRun.all.each do |s|
      test = s if s.passed?
    end
    UserMailer.test_is_passing(test)
  end
end
class UserMailer < ActionMailer::Base
  default from: CONTACT_EMAIL

  # Send email about this test. Decides
  # which actual mailer method to invoke.
  def self.notify_for(spec_run)
    if spec_run.passed?
      UserMailer.test_is_passing(spec_run).deliver
    else
      UserMailer.test_failed(spec_run).deliver
    end
  end

  def test_failed(spec_run)
    proj = spec_run.project
    @project_name = proj.name
    @project_url  = project_url(proj)
    @apps         = proj.failing_apps
    @expectations = proj.failing_expectations
    mail to: spec_run.contact_email, subject: "#{@project_name} has #{@apps.count} failing #{'app'.pluralize(@apps.count)}"
  end

  def test_is_passing(spec_run)
    @project_name = spec_run.project.name
    @project_url  = project_url(spec_run.project)
    mail to: spec_run.contact_email, subject: "All #{@project_name} requirements are passing"
  end
end

class Users::RegistrationsController < Devise::RegistrationsController
  def new
    # Provide access to special Think 200 stuff
    # to the devise sign up template
    @user_input = session[:checkit_user_input]
    if @user_input.blank?
      redirect_to root_path
    else
      super
    end
  end

  def create
    @user_input = session[:checkit_user_input]
    super

    if resource.valid?
      # Create the user's first project
      #   user's input: session[:checkit_user_input]
      #   user:         resource
      project     = Project.create!(name: 'First Project', user: resource)
      app         = App.create!(name: 'website', project: project)
      requirement = Requirement.create!(name: 'is online', app: app)
      expectation = Expectation.create!(
                                        subject:     session[:checkit_user_input],
                                        matcher:     Matcher.for('be_up'),
                                        requirement: requirement
                                        )
    end
  end
end

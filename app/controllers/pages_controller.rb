require 'think200'

class PagesController < ApplicationController
  CheckitResult = Struct.new(:is_up, :is_error)
  ERROR_MESSAGE = "Please enter a URL or domain name"

  before_action :authenticate_user!, only: [
    #:inside
  ]


  def home
    redirect_to projects_path if current_user
  end


  def checkit
    # Clean up the input and do some checking:
    # 4..2000 characters which are not in the restricted
    # group: | <> " \ ` ^ {} and all whitespace.
    # Then save the result in the session for security,
    # so that we only need to check the user input once
    # during the sign-up process.
    @user_input = params[:url_or_domain_name].strip
    unless /\A[^|<>"\\`^{}[:space:]]{4,2000}\z/ === @user_input
      flash[:alert] = ERROR_MESSAGE
    	redirect_to root_path
      return
    end
    session[:checkit_user_input] = @user_input

    test_results = check(@user_input)

    if test_results.is_error
      render 'checkit_with_error'
    else
      @expectation = Expectation.new subject: @user_input, matcher: Matcher.for('be_up')
      @is_up     = test_results.is_up
      @next_step = new_user_registration_path
      render 'checkit_is_up'
    end
  end
  

  private
  def check(url_or_domain_name)
    CheckitResult.new(false, false)  # Kinda shitty that Struct doesn't do keyword args
  end

end

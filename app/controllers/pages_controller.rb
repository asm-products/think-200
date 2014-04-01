require 'think200_libs'

class PagesController < ApplicationController
  CheckitResult = Struct.new(:is_up, :error_msg)
  ERROR_MESSAGE = "Please enter a URL or domain name"

  before_action :authenticate_user!, only: [
    # :inside
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

    results      = check(@user_input)
    @expectation = Expectation.new subject: @user_input, matcher: Matcher.for('be_up')
    @is_up       = results.is_up
    @error_msg   = results.error_msg
    @next_step   = new_user_registration_path
    @prev_step   = root_path
  end
  

  private

  def check(url_or_domain_name)
    begin
      is_up = RSpec::WebserviceMatchers.up? url_or_domain_name
      error_msg = ''
    rescue Exception => e
      is_up = false
      error_msg = e.message
    end
    
    CheckitResult.new(is_up, error_msg)
  end

end

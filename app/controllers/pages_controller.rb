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
    # Clean up the input and do some checking
    # 4..2000 characters which are not in the restricted
    # group: | <> " \ ` ^ {} and all whitespace
    @user_input = params[:url_or_domain_name].strip
    unless /\A[^|<>"\\`^{}[:space:]]{4,2000}\z/ === @user_input
      flash[:alert] = ERROR_MESSAGE
    	redirect_to root_path
      return
    end

    test_results = check(@user_input)

    if test_results.is_error
      render 'checkit_with_error'
    else
      @expectation = Expectation.new
      @expectation.subject = @user_input
      @expectation.matcher = Matcher.find_by(code: 'be_up')
      @is_up  = test_results.is_up
      render 'checkit_is_up'
    end
  end
  

  private
  def check(url_or_domain_name)
    CheckitResult.new(false, false)  # Kinda shitty that Struct doesn't do keyword args
  end

end

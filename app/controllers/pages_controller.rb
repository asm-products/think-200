class PagesController < ApplicationController
  CheckitResult = Struct.new(:status, :valid_cert, :is_redirect, :redirect_perm, :redirect_dest)
  ERROR_MESSAGE = "Please enter a URL or domain name"

  before_action :authenticate_user!, only: [
    :inside
  ]


  def home
    redirect_to projects_path if current_user
  end


  def checkit
  	# Validate and clean up the input
  	user_input = params[:url_or_domain_name].strip
    unless /\A[[:alnum:]\-.]{4,63}\z/ === user_input  # Just a safety check:
      flash[:alert] = ERROR_MESSAGE                   # valid characters & length
    	redirect_to root_path
      return
    end

    test_results = check(user_input)
    @valid_cert  = test_results.valid_cert
    if ! test_results.is_redirect
      render 'checkit_no_redirect'
    end

    flash[:alert] = "TBD"
  end
  

  private
  def check(url_or_domain_name)
    CheckitResult.new(status: 200, valid_cert: true, is_redirect: false)
  end

end

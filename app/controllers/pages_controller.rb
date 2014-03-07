class PagesController < ApplicationController
  before_action :authenticate_user!, only: [
    :inside
  ]

  def home
    redirect_to projects_path if current_user
  end

  def checkit
  	user_input = params[:url_or_domain_name]
  	redirect_to root_path if user_input.blank?

  	
  end
  
  def inside
  end 
    
end

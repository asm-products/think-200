class PagesController < ApplicationController
  before_action :authenticate_user!, only: [
    :inside
  ]

  def home
    redirect_to projects_path if current_user
  end
  
  def inside
  end 
    
end

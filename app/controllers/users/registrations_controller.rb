class Users::RegistrationsController < Devise::RegistrationsController
  def new
    @user_input = session[:checkit_user_input]
    super
  end

  # def create
  #   super
  # end
end

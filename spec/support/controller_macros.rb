module ControllerMacros
  def login_user
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      user = User.create email: 'foo@bar.com', password: 'sekret', username: 'iggy'
      user.confirm!
      sign_in user
    end
  end
end
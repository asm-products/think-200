require 'spec_helper'

describe Users::RegistrationsController, '#new' do
  describe 'without valid params' do
    it 'redirects to the home page' do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      get :new
      response.status.should eq 302
      response.location.should eq root_url
    end
  end
end


describe Users::RegistrationsController, '#create' do
  let(:valid_create_params) do
    {
      user: {
        username: "validname", 
        email: "valid@email.com", 
        password:              "sekret", 
        password_confirmation: "sekret"
      }
    }
  end

  let(:session_with_stored_url) { {checkit_user_input: "stackoverflow.com"} }

  describe "with valid params" do
    it "creates the user" do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      expect {
        post :create, valid_create_params, session_with_stored_url
      }.to change{ User.count }.by(1)
      expect(response.redirect_url).to eq('http://test.host/')
    end

    it "creates the project" do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      expect {
        post :create, valid_create_params, session_with_stored_url
      }.to change{ Project.count }.by(1)
      expect(response.redirect_url).to eq('http://test.host/')
    end
  end

  describe "with an invalid user param" do
    render_views

    it "gives a good error message" do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      bad_create_params = valid_create_params.dup
      bad_create_params[:user][:username] = 'bad username has spaces'
      post :create, valid_create_params.merge( user: {username: 'bad username has spaces'} ), session_with_stored_url
      expect(response).to render_template("new")
      expect(response.body).to match /Username can only contain letters and digits/m
    end

    it 'presents the stored url' do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      bad_create_params = valid_create_params.dup
      bad_create_params[:user][:username] = 'bad username has spaces'
      post :create, valid_create_params.merge( user: {username: 'bad username has spaces'} ), session_with_stored_url
      expect(response).to render_template("new")
      expect(response.body).to match /#{session_with_stored_url[:checkit_user_input]}/
    end
  end
end

require 'spec_helper'

describe Users::RegistrationsController, '#new' do
  describe 'without valid params - e.g. skipping the home page' do
    it 'redirects to the home page' do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      get :new
      response.status.should eq 302
      response.location.should eq root_url
    end
  end
end


describe Users::RegistrationsController, '#create' do
  let(:valid_user_form_params) do
    {
      user: {
        username:              "snacky", 
        email:                 "me@email.com", 
        password:              'my Password %@#{^&!}123', 
        password_confirmation: 'my Password %@#{^&!}123'
      }
    }
  end
  let(:session_data) { {checkit_user_input: "stackoverflow.com"} }

  # describe "with valid params" do
    # it "creates the new user and first project" do
    #   @request.env["devise.mapping"] = Devise.mappings[:user]
    #   users = User.count
    #   projects = Project.count

    #   post :create, valid_user_form_params, session_data

    #   User.count.should eq(users + 1)
    #   Project.count.should eq(projects + 1)
    # end
  # end

  describe "with an invalid user form response" do
    render_views

    it 'redirects to new and re-presents the stored url' do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      post :create, valid_user_form_params.merge( user: {username: 'bad username has spaces'} ), session_data
      expect(response).to render_template("new")
      expect(response.body).to match /#{session_data[:checkit_user_input]}/
    end
  end
end

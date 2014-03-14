require 'spec_helper'

describe AjaxController do
  login_user

  describe "GET 'queue_status'" do
    it "returns http success" do
      get 'queue_status'
      response.should be_success
    end
  end

end

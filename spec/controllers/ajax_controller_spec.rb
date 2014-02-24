require 'spec_helper'

describe AjaxController do

  describe "GET 'queue_status'" do
    it "returns http success" do
      get 'queue_status'
      response.should be_success
    end
  end

end

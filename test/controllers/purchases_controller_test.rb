require 'test_helper'

class PurchasesControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers  

  test "redirected if not logged in" do
    get(:new)
    assert_response :redirect
    
  end
end

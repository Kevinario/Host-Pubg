require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest

  test 'should get Home' do
    get root_url
    assert_response :success
  end
  
  test 'should get FAQ' do
    get faq_url
    assert_response :success
  end
  
  test 'should get About' do
    get about_url
    assert_response :success
  
end

require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers
  
  test 'logged out home elements' do
    get(:homepage)
    assert_response :success
    assert_template 'static_pages/homepage'
    
    assert_select "a[href=?]", new_purchase_url , count: 1
    assert_select "a[href=?]", blog_path , count: 1
    assert_select "a[href=?]", about_path , count: 1
    assert_select "a[href=?]", root_path , count: 1
    assert_select "a[href=?]", faq_path , count: 1
    #Not signed in Links
    assert_select "a[href=?]", new_user_session_path, count: 1
    assert_select "a[href=?]", account_url, count: 0
    assert_select "a[href=?]", destroy_user_session_path, count: 0
  end
  
  test 'logged in home elements' do
    @request.env["devise_mapping"] = Devise.mappings[:user]
    sign_in FactoryBot.create(:user)
    get(:homepage)
    
    assert_response :success
    assert_template 'static_pages/homepage'
    #Logged in assertions
    assert_select "a[href=?]", account_url, count: 1
    assert_select "a[href=?]", destroy_user_session_path, count: 1
    assert_select "a[href=?]", new_user_session_path, count: 0
    
  end
  
  
  test 'should get FAQ' do
    get(:faq)
    assert_response :success
    assert_template 'static_pages/faq'
    assert_select "a[href=?]", blog_path , count: 1
    assert_select "a[href=?]", about_path , count: 1
    assert_select "a[href=?]", root_path , count: 1
    assert_select "a[href=?]", faq_path , count: 1
  end
  
  test 'should get About' do
    get(:about)
    assert_response :success
    assert_template 'static_pages/about'
    assert_select "a[href=?]", blog_path , count: 1
    assert_select "a[href=?]", about_path , count: 1
    assert_select "a[href=?]", root_path , count: 1
    assert_select "a[href=?]", faq_path , count: 1
  end
end

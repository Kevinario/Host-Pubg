require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers
  
  def post_setup
    i = 0
    while i<10 do
      FactoryBot.create(:post)
      i+=1
    end
    @posts = Post.all
  end
  
  
  test "logged out elements index" do
    post_setup
    get(:index)
    
    assert_template 'posts/index'
    assert_select "a[href=?]", blog_path , count: 1
    assert_select "a[href=?]", about_path , count: 1
    assert_select "a[href=?]", root_path , count: 1
    assert_select "a[href=?]", faq_path , count: 1
    #Not signed in Links
    assert_select "a[href=?]", new_user_session_path, count: 1
    assert_select "a[href=?]", account_url, count: 0
    assert_select "a[href=?]", destroy_user_session_path, count: 0
    
    
    @posts.each do |post|
      assert_select "a[href=?]", post_path(post.id), count: 1
      assert_select "a[href=?]", edit_post_path(post.id), count:0
      assert_select "a[href=?]", post_path(post.id), text: "Delete", count: 0
    end
    assert_select "a[href=?]", posts_path, count: 0
  
  end
  
  test "logged in elements index" do
    post_setup
    @request.env["devise_mapping"] = Devise.mappings[:user]
    sign_in FactoryBot.create(:user)
    get(:index)
    
    assert_template 'posts/index'
    assert_select "a[href=?]", blog_path , count: 1
    assert_select "a[href=?]", about_path , count: 1
    assert_select "a[href=?]", root_path , count: 1
    assert_select "a[href=?]", faq_path , count: 1
    #Signed in Links
    assert_select "a[href=?]", new_user_session_path, count: 0
    assert_select "a[href=?]", account_url, count: 1
    assert_select "a[href=?]", destroy_user_session_path, count: 1
    
    @posts.each do |post|
      assert_select "a[href=?]", post_path(post.id), count: 1
      assert_select "a[href=?]", edit_post_path(post.id), count:0
      assert_select "a[href=?]", post_path(post.id), text: "Delete", count: 0
    end
    assert_select "a[href=?]", posts_path, count: 0
    
  end
  
  test "logged in admin elements index" do
    post_setup
    @request.env["devise_mapping"] = Devise.mappings[:user]
    sign_in FactoryBot.create(:admin)
    get(:index)
    
    assert_template 'posts/index'
    assert_select "a[href=?]", blog_path , count: 1
    assert_select "a[href=?]", about_path , count: 1
    assert_select "a[href=?]", root_path , count: 1
    assert_select "a[href=?]", faq_path , count: 1
    #Signed in Links
    assert_select "a[href=?]", new_user_session_path, count: 0
    assert_select "a[href=?]", account_url, count: 1
    assert_select "a[href=?]", destroy_user_session_path, count: 1
    
    @posts.each do |post|
      assert_select "a[href=?]", post_path(post.id), count: 2
      assert_select "a[href=?]", edit_post_path(post.id), count: 1
      assert_select "a[href=?]", post_path(post.id), text: "Delete", count: 1
    end
    assert_select "a[href=?]", posts_path, count: 1
    

  end
  
  test "new post redirect if not logged in" do
    get(:new)
    assert_response :redirect
  end
  
  test "edit post redirect if not logged in" do
    post = FactoryBot.create(:post)
    get(:edit, id: post.id)
    assert_response :redirect
  end  
  
  test "new post redirect if normal user" do
    @request.env["devise_mapping"] = Devise.mappings[:user]
    sign_in FactoryBot.create(:user)
    get(:new)
    assert_response :redirect
  end
  
  test "edit post redirect if normal user" do
    @request.env["devise_mapping"] = Devise.mappings[:user]
    sign_in FactoryBot.create(:user)
    post = FactoryBot.create(:post)
    get(:edit, id: post.id)
    assert_response :redirect
  end  
  
  
  test "new post if admin" do
    @request.env["devise_mapping"] = Devise.mappings[:user]
    sign_in FactoryBot.create(:admin)
    get(:new)
    assert_response :success
  end
  
  test "edit post if admin" do
    @request.env["devise_mapping"] = Devise.mappings[:user]
    sign_in FactoryBot.create(:admin)
    post = FactoryBot.create(:post)
    get(:edit, id: post.id)
    assert_response :success
  end
  
  test "logged out tries to make post" do
    assert_no_difference 'Post.all.count' do
     post(:create, post: {title: "testTitle", postText: "testPostText"})
      assert_response :redirect
    end
  end
  
  test "non admin user tries to make post" do
    @request.env["devise_mapping"] = Devise.mappings[:user]
    sign_in FactoryBot.create(:user)
    
    assert_no_difference 'Post.all.count' do
      post(:create, post: {title: "testTitle", postText: "testPostText"})
      assert_response :redirect
    end
  
  end
  
  test "admin can make post" do
    @request.env['devise_mapping'] = Devise.mappings[:user]
    sign_in FactoryBot.create(:admin)
    
    assert_difference 'Post.all.count', 1 do
      post(:create, post: {title: "testTitle", postText: "testPostText"})
    end
  end
  
  
  test "update post fail as logged out" do
    createdPost = FactoryBot.create(:post)
    
    patch(:update, id: createdPost.id, post: {title: "testTitle", postText: "testPostText"})
    newPost = Post.find(createdPost.id)
    
    assert newPost.postText != "testPostText"
    assert newPost.title != "testTitle"
    assert newPost.updated_at == createdPost.updated_at
    assert_response :redirect
  end
  
  test "update post fail as user" do
    @request.env['devise_mapping'] = Devise.mappings[:user]
    sign_in FactoryBot.create(:user)
    
    createdPost = FactoryBot.create(:post)
    
    patch(:update, id: createdPost.id, post: {title: "testTitle", postText: "testPostText"})
    newPost = Post.find(createdPost.id)
    
    assert newPost.postText != "testPostText"
    assert newPost.title != "testTitle"
    assert newPost.updated_at == createdPost.updated_at
    assert_response :redirect
  end
  
  test "update post success as admin" do
    @request.env['devise_mapping'] = Devise.mappings[:user]
    sign_in FactoryBot.create(:admin)
    createdPost = FactoryBot.create(:post)
    
    patch(:update, id: createdPost.id, post: {title: "textTitle", postText: "testPostText"})
    newPost = Post.find(createdPost.id)
    
    assert newPost.postText = "testPostText"
    assert newPost.title = "textTitle"
    assert newPost.updated_at != createdPost.updated_at
    assert_response :redirect
  end
  
  test "delete post fail as logged out" do
    createdPost = FactoryBot.create(:post)
    
    assert_no_difference 'Post.all.count' do
      delete(:destroy, id: createdPost.id)
      assert_response :redirect
    end
    
  end
  
  
  test "delete post fail as user" do
    @request.env['devise_mapping'] = Devise.mappings[:user]
    sign_in FactoryBot.create(:user)
    
    createdPost = FactoryBot.create(:post)
    
    assert_no_difference 'Post.all.count' do
      delete(:destroy, id: createdPost.id)
      assert_response :redirect
    end
  end
  
  test "delete post success as admin" do
    @request.env['devise_mapping'] = Devise.mappings[:user]
    sign_in FactoryBot.create(:admin)
    
    createdPost = FactoryBot.create(:post)
    
    assert_difference 'Post.all.count', -1 do
      delete(:destroy, id: createdPost.id)
      assert_response :redirect
    end
  end
  
  
  
end

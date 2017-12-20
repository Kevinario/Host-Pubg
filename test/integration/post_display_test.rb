require 'test_helper'

class PostDisplayTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  
  def setup
    @posts = Post.all
    #@admin = users(:adminAccount)
  end
  test "All Users can view posts" do
    get blog_path
    @posts.each do |post|
      assert_select "a[href=?]", post_path(post.id)
    end
  end
  
  test "Admin can post" do
    #@admin = User.create(email: "adminemail@gmail.com", password: Devise::Encryptor.digest(User,"test123"))
    #post user_session_path, 'user[email]' => @admin.email, 'user[password]' => @admin.password
    #@admin.admin = true
    #@admin.save
    #assert @admin.admin
    #assert_equal(current_user.id,@admin.id)
    #assert_difference 'Post.count', 1 do
     # post posts_path, params: { post: {title: "This is a title", postText: "This is some text"}}
    #  post posts_path, 'post[title]' => "This is a title", 'post[postText]' => "This is some text"   #post: { title: "This is a title", postText: "This is some text" } 'post[title]' => "This is a title", 'post[postText]' => "This is some text"              post: { title: "This is a title", postText: "This is some text" }
    #end
    
    
  
  end
  
end

class PostsController < ApplicationController
    before_action :set_post, only: [:edit,:update,:destroy,:show]
    before_action :check_admin, only: [:new,:create,:destroy,:edit,:update,:destroy]
    def index
        @posts = Post.all
    end
    
    def new
        @post = Post.new
    end
    
    def create
        @post = Post.create(post_params)
        redirect_to posts_path
    end
    
    def edit
    end
    
    def show
    end
    
    def update
        @post.update(post_params)
        redirect_to posts_path
    end
    
    def destroy
        @post.destroy
        redirect_to posts_path
    end
    
    private
    
    def post_params
        params.require(:post).permit(:title,:postText)
    end
    
    def set_post
        @post = Post.find(params[:id])
    end
    
    def check_admin
        if not current_user.try(:admin?)
            redirect_to posts_path
        end
    end
end

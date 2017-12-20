class CancellationsController < ApplicationController
    before_action :authenticate_user!
    
    def show
        @server = Post.find(params[:id])
        if(server.user_id != current_user.id)
            #Not the right User
            redirect_to root_url
            return
        end
    end
    
end

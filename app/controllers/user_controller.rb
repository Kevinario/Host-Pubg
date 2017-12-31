class UserController < ApplicationController
    before_action :authenticate_user!
    before_action :select_server, :correct_user, :server_cancelled, :server_not_active, only: [:manage]
    
    def show
        @user = current_user
        @activeServers = Purchase.where(user_id: current_user.id, active: true)
    end
    
    def manage
        
    end
    
    
    private
    
        def select_server
            @server = Purchase.find(params[:id])
        end
        
        def correct_user
            if(@server.user_id != current_user.id)
                #Not the right User
                flash[:danger] = "You do not have access to that server"
                redirect_to root_url
                return
            end
        end
        
        def server_cancelled
            if @server.cancelled
                flash[:danger] = "Server is cancelled"
                redirect_to account_url
                return
            end
        end
        
        def server_not_active
            if !@server.active
                flash[:danger] = "Server is not active"
                redirect_to account_url
                return
            end
        end
end

class CancellationsController < ApplicationController
    before_action :authenticate_user!
    before_action :select_server, :correct_user
    before_action :server_cancelled, only: [:new,:create]
    
    
    def new
    end
    
    def create
        @server.update(cancelled: true)
        flash[:warning] = "Server currently cancelled. It may be re-enabled before " + @server.expireDate.to_default_s
        redirect_to account_url
    end
    
    def re_enable
        
        if !@server.cancelled
            flash[:primary] = "That server has not been cancelled"
            redirect_to account_url
            return
        end
        
        if !@server.active
            flash[:danger] = "That server has expired. It must be renewed to be re-enabled"
            redirect_to account_url
            return
        end
        
        @server.update(cancelled:false)
        flash[:success] = "That server has been re_enabled"
        redirect_to account_url
        
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
                flash[:danger] = "Server already cancelled"
                redirect_to account_url
                return
            end
        end
    
end

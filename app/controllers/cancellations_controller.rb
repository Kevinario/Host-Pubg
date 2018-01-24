class CancellationsController < ApplicationController
    before_action :authenticate_user!
    before_action :select_server, :correct_user
    before_action :server_cancelled, only: [:new,:create]
    
    
    def new
    end
    
    def create
        customer = get_stripe_user(current_user.email)
        
        @current_sub =  nil
        
        customer.subscriptions.data.select do |subscription|
            if subscription.metadata.order_id.to_i == @server.id
                @current_sub = subscription
                break
            end
        end
        
        if @current_sub.nil?
            flash[:danger] = "Could not find subscription"
            redirect_to account_url
            return
        end
        
        flash[:warning] = "Server currently cancelled. It may be re-enabled before " + @server.expireDate.to_default_s
        @server.update(cancelled: true)
        @current_sub.delete(at_period_end: true)
        redirect_to account_url
    end
    
    def re_enable
        
        if !@server.cancelled
            flash[:primary] = "That server has not been cancelled"
            redirect_to account_url
            return
        end
        
        
        customer = get_stripe_user(current_user.email)
        
        @current_sub = nil
        
        customer.subscriptions.data.select do |subscription|
            if subscription.metadata.order_id.to_i == @server.id
                @current_sub = subscription
                break
            end
        end
        
        if @current_sub.nil?
            flash[:danger] = "Could not find that subscription"
            redirect_to account_url
            return
        end
        
        @current_sub.items.data[0].plan = @server.plan
        @current_sub.save
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
        
        def get_stripe_user(email)
            allCustomers = Stripe::Customer.all
            allCustomers.select do |c|
                if c.email == email
                    return c
                end
            end
            return nil
        end
    
end

class RenewController < ApplicationController
    before_action :authenticate_user!
    before_action :select_server, :correct_user
    
    def new
        
    end
    
    def create
        renewUntil = (@server.expireDate + 1.month).to_default_s
        @amount = 4000
        begin
            charge = Stripe::Charge.create(
                :amount => @amount,
                :currency => 'usd',
                :description => 'Server renew until' + renewUntil,
                :source => params[:stripeToken]
                )
        rescue Stripe::CardError => e
            #Users card was declined
            flash[:danger] = "Card Error Encountered"
            redirect_to renew_url(@server.id)
            return
        
        rescue => e
            #Something else went wrong
            flash[:danger] = "Error Encountered"
            redirect_to renew_url(@server.id)
            return
        end
        
        flash[:success] = "Server renewed until" + renewUntil
        @server.update(expireDate: @server.expireDate + 1.month)
        redirect_to account_url
    end
    
    
    
    private
    
        def select_server
            @server = Purchase.find(params[:id])
        end
        
        def correct_user
            if @server.user_id != current_user.id
                flash[:danger] = "You do not have access to that server"
                redirect_to root_url
            end
        end
    
end

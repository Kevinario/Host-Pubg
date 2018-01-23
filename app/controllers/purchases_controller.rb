class PurchasesController < ApplicationController
    before_action :authenticate_user!
    #before_action :no_active_purchases
    
    def new
        @purchase = Purchase.new
    end
    
    def create
        @amount = 4000
        @user = current_user
        
        
        #Really dodgy implementation, really need to work on improving this at some point
        
        customer = nil
        allCustomers = Stripe::Customer.all
        allCustomers.select do |c|
            if c.email == @user.email
                customer = c
                break
            end
        end
        
        if customer.nil?
            begin
                customer = Stripe::Customer.create(
                    :email => @user.email,
                    :source => params[:stripeToken],
                    )
            rescue Stripe::CardError => e
                #Card Error
                flash[:danger] = "Card Error Encountered"
                redirect_to new_purchase_url
                return 
                
            rescue Stripe::StripeError => e
                #Generic Error
                flash[:danger] = "Stripe Error Encountered"
                redirect_to new_purchase_url
                return
                
            rescue => e
                flash[:danger] = "Generic Error Encountered"
                redirect_to new_purchase_url
                return
                
            end
        end
        
        begin
            subscription = Stripe::Subscription.create(
                :customer => customer.id,
                :items => [{:plan => "standard"}],
                :metadata => {order_id: Purchase.count + 1}
                )
        rescue Stripe::StripeError => e
            flash[:danger] = "Stripe Error Encountered"
            redirect_to new_purchase_url
            return
            
        rescue => e
            flash[:danger] = "Generic Error Encountered"
            redirect_to new_purchase_url
            return
            
        end
        
        flash[:success] = "Subscription created"
        
        #if
        @purchase = Purchase.create(:location => purchase_params[:location],:user_id => current_user.id,:plan => "standard",:expireDate => Time.now,:purchaseTime => Time.now,:active => false,:cancelled => false)
            #unless @server = Server.create(:name => "Default", :status => "Offline", :purchase_id => @purchase.id)
                #Server Error handler here
            #end
        #else
            #purchase creating error
        #end
        redirect_to root_url
    end
    
    private
    
    def purchase_params
        params.require(:purchase).permit(:location,:renew)
    end
    
end

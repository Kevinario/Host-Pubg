class PurchasesController < ApplicationController
    before_action :authenticate_user!
    #before_action :no_active_purchases
    
    def new
        @purchase = Purchase.new
    end
    
    def create
        @amount = 4000
        begin
            charge = Stripe::Charge.create(
                :amount => @amount,
                :currency => 'usd',
                :description => 'Server Setup',
                :source => params[:stripeToken]
                )
        rescue Stripe::CardError => e
            #Users card was declined
            flash[:danger] = "Card Error Encountered"
            redirect_to new_purchase_url
            return
        
        rescue => e
            #Something else went wrong
            flash[:danger] = "Error Encountered"
            redirect_to new_purchase_url
            return
        end
        
        flash[:success] = "Card has been accepted"
        @purchase = Purchase.create(:renew => purchase_params[:renew],:location => purchase_params[:location],:user_id => current_user.id,:plan => "standard",:expireDate => Time.now.to_date + 1.month,:purchaseTime => Time.now,:active => true,:cancelled => false)
        redirect_to root_url
    end
    
    private
    
    def purchase_params
        params.require(:purchase).permit(:location,:renew)
    
    end
    
end

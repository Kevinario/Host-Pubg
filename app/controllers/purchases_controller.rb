class PurchasesController < ApplicationController
    before_action :authenticate_user!, only: [:new]
    
    def new
        if(Purchase.find_by(user_id: current_user.id, cancelled: false, active: false))
            #Change to payment url later
            redirect_to root_url
        else
            @purchase = Purchase.new
        end
    end
    
    def create
        @purchase = Purchase.create(:renew => purchase_params[:renew],:location => purchase_params[:location],:user_id => current_user.id,:plan => "standard",:expireDate => Time.now.to_date,:purchaseTime => Time.now,:active => false,:cancelled => false)
        redirect_to root_url
    end
    
    private
    
    def purchase_params
        params.require(:purchase).permit(:location,:renew)
    
    end
end

class PaymentsController < ApplicationController
    before_action :authenticate_user!
    before_action :active_purchase_exists
    
    def new
        @activePurchase = Purchase.find_by(user_id: current_user.id, cancelled: false, active: false)
        
    
    end
    
    
    private
    
    def active_purchase_exists
        unless Purchase.find_by(user_id: current_user.id, cancelled: false, active: false)
        redirect_to new_purchase_url
        return
        end
    end
end

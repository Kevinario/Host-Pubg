class PurchasesController < ApplicationController
    before_action :authenticate_user!, only: [:new]
    
    def new
    end
end

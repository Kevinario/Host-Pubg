class UserController < ApplicationController
    before_action :authenticate_user!
    def show
        @user = current_user
        @activeServers = Purchase.where(user_id: current_user.id, active: true)
    end
end

class UserController < ApplicationController
    before_action :authenticate_user!
    def show
        #@servers = User.find_by
    end
end

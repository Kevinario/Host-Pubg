module ApplicationHelper
    
    def loggedState
        if user_signed_in?
            return [(link_to "Logout", destroy_user_session_path, method: :delete)]
        else
            return [(link_to "Login", new_user_session_path),(link_to "Signup", new_user_registration_path)]
        end
    end
end

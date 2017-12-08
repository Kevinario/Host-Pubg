module ApplicationHelper
    
    def loggedState
        if user_signed_in?
            return (link_to "Logout", destroy_user_session_path, method: :delete)
        else
            return (link_to "Login", new_user_session_path)
        end
    end
    
    def user_profile
        if user_signed_in?
            return (link_to "Account", account_url)
        end
    end
end

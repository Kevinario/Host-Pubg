module PostsHelper
    
    def timeDisplay(created_at,updated_at)
        if created_at == updated_at
            return "Posted at " + created_at.to_formatted_s(:long)
        else
            return "Updated at " + updated_at.to_formatted_s(:long)
        end
    end
end

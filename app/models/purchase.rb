class Purchase < ActiveRecord::Base
    belongs_to :user
    has_one :server
end

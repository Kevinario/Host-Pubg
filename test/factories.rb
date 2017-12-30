require 'faker'

FactoryBot.define do
    factory :user do
        email { Faker::Internet.email }
        password "password"
        password_confirmation "password"
        confirmed_at Date.today
        admin false
    end
    
    
    factory :admin, class: User do
        email { Faker::Internet.email }
        password "password"
        password_confirmation "password"
        confirmed_at Date.today
        admin true
    end
    
    factory :unconfirmed, class: User do
        email { Faker::Internet.email }
        password "password"
        password_confirmation "password"
        confirmed_at nil
    end
    
    factory :post do
        title { Faker::Coffee.variety }
        postText { Faker::Coffee.blend_name }
        @time = Faker::Time.between(Time.now - 1, Time.now)
        created_at @time
        updated_at @time
    end
end
FactoryGirl.define do

  factory :user do
    username "Username"
    email "username@service.com"
    password "simple_password"
    password_confirmation "simple_password"
  end

  factory :other_user, class: User do
    username "Friend"
    email "friend@service.com"
    password "simple_password"
    password_confirmation "simple_password"
  end

  factory :user_with_avatar, class: User do
    avatar { File.new(Rails.root.join('app', 'assets', 'images', 'rails.png')) } 
  end

end

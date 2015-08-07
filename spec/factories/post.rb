FactoryGirl.define do
  factory :post do
    title "PostTitle"
    text "PostText"
    #picture { File.new(Rails.root.join('app', 'assets', 'images', 'rails.png')) }
    picture Rack::Test::UploadedFile.new("#{Rails.root}/app/assets/images/rails.png", "image/png")
  end

  factory :another_post, class: Post do
    title "AnotherPostTitle"
    text "AnotherPostText"
    picture Rack::Test::UploadedFile.new("#{Rails.root}/app/assets/images/rails.png", "image/png")
  end

  factory :post_empty_title, class: Post do
    title nil
    text "PostText"
    picture { File.new(Rails.root.join('app', 'assets', 'images', 'rails.png')) }
  end

  factory :post_empty_text, class: Post do
    title "PostTitle"
    text nil
    picture { File.new(Rails.root.join('app', 'assets', 'images', 'rails.png')) }
  end

  factory :post_empty_picture, class: Post do
    title "PostTitle"
    text "PostText"
    picture nil
  end
  
end

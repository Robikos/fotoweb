include Warden::Test::Helpers
Warden.test_mode!

def login_backend(request, user_symbol)
  request.env["devise.mapping"] = Devise.mappings[user_symbol]
  user = FactoryGirl.create(user_symbol)
  sign_in user
end

def login_frontend
  user = FactoryGirl.create(:user)
  login_as user, scope: :user
end

def photo_path
  "#{Rails.root}/app/assets/images/rails.png"
end

def add_photo_frontend(post_sym)
  find_link('Add a new post!').click
  post = FactoryGirl.build(post_sym)

  fill_in 'title_field', with: post.title
  fill_in 'text_field', with: post.text
  attach_file 'picture_field', photo_path

  click_on 'Add!'
  expect(page).to have_selector('div.post-details', visible: true)
end

def assign_post_to_user(user, post)
  post.user_id = user.id
  post.save

  post.created_at
end

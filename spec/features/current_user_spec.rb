require 'spec_helper'

feature "Current User page", js: true do

  background do
    login_frontend
    visit '/users'
  end

  scenario "displays current user partial" do
    expect(page).to have_content "Logged in as:"
  end

  scenario "displays actual user partial with current user data" do
    user = FactoryGirl.build(:user)
    expect(page).to have_content "Username: #{user.username}"
  end

  scenario "displays new posts after creating" do
    post = FactoryGirl.build(:post)
    add_photo_frontend(:post)

    expect(page).to have_content "Posts: 1"
    expect(page).to have_css "div.post-details", count: 1
    within ".post-details" do
      expect(page).to have_content post.title
    end
  end

  scenario "displays exact number of added posts" do
    add_photo_frontend(:post)
    add_photo_frontend(:another_post)

    expect(page).to have_content "Posts: 2"
    expect(page).to have_css "div.post-details", count: 2
  end
  
end

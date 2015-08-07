require 'spec_helper'

feature "User page", js: true do

  background do
    login_frontend
    @user = FactoryGirl.create(:other_user)
    visit '/users/Friend/posts'
  end

  scenario "displays current user partial" do
    current_user = FactoryGirl.build(:user)
    expect(page).to have_content "Logged in as: #{current_user.username}"
  end

  scenario "displays actual user partial with proper data" do
    expect(page).to have_content "Username: #{@user.username}"
  end

  scenario "displays new posts after creating" do
    post = FactoryGirl.build(:post)
    assign_post_to_user(@user, post)
    visit '/users/Friend/posts'

    expect(page).to have_content "Posts: 1"
    expect(page).to have_css "div.post-details", count: 1
    within ".post-details" do
      expect(page).to have_content post.title
    end
  end

  scenario "displays exact number of added posts" do
    post = FactoryGirl.build(:post)
    another_post = FactoryGirl.build(:another_post)
    assign_post_to_user(@user, post)
    assign_post_to_user(@user, another_post)
    visit '/users/Friend/posts'

    expect(page).to have_content "Posts: 2"
    expect(page).to have_css "div.post-details", count: 2
  end
  
end

require 'spec_helper'

feature "Home page", js: true do

  scenario "displays login and register links at default" do
    visit '/'
    expect(page).to have_content "Log in or Register!"
  end

  scenario "displays current user info after logging in" do
    login_frontend
    visit '/'

    expect(find('.current-user-info')).to have_content "Logged in as:"
    expect(find('.current-user-info')).to have_content "Registered at:"
  end

  scenario "includes valid link to create new post" do
    login_frontend
    visit '/'
    click_link 'Add a new post!'

    expect(current_path).to eq('/users/Username/posts/new')
  end

  scenario "includes valid link to show user friends" do
    login_frontend
    visit '/'
    click_link 'Friends'

    expect(current_path).to eq('/users/Username/friendships')
  end

  scenario "includes valid link to log out" do
    login_frontend
    visit '/'
    click_link 'Log out'

    expect(page).to have_content "Log in or Register!"
  end

end

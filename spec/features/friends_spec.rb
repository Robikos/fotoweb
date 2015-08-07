require 'spec_helper'

feature "Friendships features", js: true do

  background do
    login_frontend
  end

  scenario 'dont allow to invite yourself to friends' do
    visit '/users'

    expect(page).to have_selector '.user-info', visible: true

    within '.user-info' do
      expect(page).to have_content 'It is you'
    end
  end

  scenario 'doesnt provide friendship without inviting' do
    user = FactoryGirl.create(:other_user)
    visit '/users/Friend/posts'

    expect(page).to have_selector '.user-info', visible: true

    within '.user-info' do
      expect(page).to have_selector 'a#add_friend_link'
    end
  end

  scenario 'display friendship after inviting' do
    user = FactoryGirl.create(:other_user)
    visit '/users/Friend/posts'

    expect(page).to have_selector '.user-info', visible: true

    find_link('add_friend_link').click

    within '.user-info' do
      expect(page).to have_content 'Friends'
    end
  end

  scenario 'provide valid removing user from friends' do
    user = FactoryGirl.create(:other_user)
    visit '/users/Friend/posts'

    expect(page).to have_selector '.user-info', visible: true

    find_link('add_friend_link').click
    sleep 1
    find_link('remove_friend_link').click

    within '.user-info' do
      expect(page).to have_selector 'a#add_friend_link'
    end
  end
  
end

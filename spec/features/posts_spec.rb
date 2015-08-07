require 'spec_helper'

feature 'User posts page', js: true do
  
  background do
    login_frontend
    @user = FactoryGirl.create(:other_user)
    visit '/users/Friend/posts'
  end

  scenario 'should display no posts after user creation' do
    expect(current_path).to eq('/users/Friend/posts')
    expect(page).to have_selector('.user-info', visible: true)
    within '.user-info' do expect(page).to have_content 'Posts: 0' end
    expect(page).to have_no_selector 'div.post-details'
  end

  scenario 'should display correct count of posts' do
    post = FactoryGirl.build(:post)
    another_post = FactoryGirl.build(:another_post)

    assign_post_to_user(@user, post)
    visit '/users/Friend/posts'

    within '.user-info' do expect(page).to have_content 'Posts: 1' end
    expect(page).to have_css 'div.post-details', count: 1

    assign_post_to_user(@user, another_post)
    visit '/users/Friend/posts'    

    within '.user-info' do expect(page).to have_content 'Posts: 2' end
    expect(page).to have_css 'div.post-details', count: 2
  end

  scenario 'should display correct post data' do
    post = FactoryGirl.build(:post)
    creation_datetime = assign_post_to_user(@user, post)
    creation_date, creation_time, zone = creation_datetime.to_s.split()
    visit '/users/Friend/posts'
    expect(page).to have_selector('div.post-details', visible: true)

    within 'div.post-details' do
      expect(page).to have_content post.title
      expect(page).to have_content creation_time[0..4]
      expect(page).to have_content creation_date
    end
  end

  scenario 'should display modal window after click post' do
    post = FactoryGirl.build(:post)
    assign_post_to_user(@user, post)
    visit '/users/Friend/posts'
    
    find_link('show_modal_link').click
    expect(page).to have_selector '.post-show', visible: true
    within 'div.post-show' do expect(page).to have_content post.title end
  end

  scenario 'modal should display no likes for new post' do
    post = FactoryGirl.build(:post)
    assign_post_to_user(@user, post)
    visit '/users/Friend/posts'
    
    find_link('show_modal_link').click
    within 'div.post-show' do expect(page).to have_content "Nobody likes it yet."end
  end

end

require 'spec_helper'

describe Post, type: :model do

  it 'should fail validation with empty title' do
    post = FactoryGirl.build(:post_empty_title)
    expect(post).not_to be_valid
  end

  it 'should fail validation with empty text' do
    post = FactoryGirl.build(:post_empty_text)
    expect(post).not_to be_valid
  end

  it 'should fail validation with empty picture' do
    post = FactoryGirl.build(:post_empty_picture)
    expect(post).not_to be_valid
  end

end

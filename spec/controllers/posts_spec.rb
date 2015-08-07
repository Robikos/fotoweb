require 'spec_helper'

describe PostsController, type: :controller do

  describe "Index action" do

    subject(:posts) {JSON.parse(response.body)["posts"]}

    context "with valid user" do

      before do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        user = FactoryGirl.create(:user)
        sign_in user

        get :index, format: :json, user_id: "Friend"
      end

      it 'should have valid response' do
        expect(response).to be_success
        expect(response.status).to eq(200)
      end

      it 'should return no posts default' do
        expect(posts).to be_nil
      end
    
    end

    context "for non existing user" do

      before do
        get :index, format: :json, user_id: "Stranger"
      end

      it 'should have valid response' do
        expect(response).to be_success
        expect(response.status).to eq(200)
      end

      it 'should return null for posts' do
        expect(posts).to eq(nil)
      end

    end

  end

  describe "Create action" do

    context "without logging in" do

      before do
        post :create, format: :json,
          user_id: "User",
          title: "Post Title",
          text: "Sample text",
          picture: nil
      end

      it 'should return failed response' do
        expect(response).not_to be_success
        expect(response.status).to eq(401)
      end

    end

    context "with logging in" do

      before do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        user = FactoryGirl.create(:user)
        sign_in user

        post :create, format: :json, user_id: "Username", post: FactoryGirl.build(:post).attributes
      end

      # it 'should fail route with empty username' do
      #   post :create, format: :json,
      #     user_id: nil,
      #     title: "Post Title",
      #     text: "Sample text",
      #     picture: nil

      #   expect(response).not_to be_success
      #   expect(response.status).to eq(500)
      # end

      subject (:result) {JSON.parse(response.body)}

      it 'should return valid response with valid post' do
        expect(response).to be_success
        expect(response.status).to eq(200)
      end

      it 'should return added post' do
        post_mock_attr = FactoryGirl.build(:post).attributes
        expect(result["post"]["title"]).to eq(post_mock_attr["title"])
        expect(result["post"]["text"]).to eq(post_mock_attr["text"])
        # expect(result["post"]["picture_file_name"]).to eq(post_mock_attr["picture_file_name"])
      end

      # it 'should return post which is included in user posts' do

      #   added_id = result["post"]["id"]
      #   get :index, user_id: "Username"
      #   first_id = result["posts"][0]["id"]

      #   expect(added_id).to eq(first_id)
      # end

    end

  end

end

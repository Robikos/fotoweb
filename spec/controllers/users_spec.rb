require 'spec_helper'

describe UsersController, type: :controller do
  describe "Index action" do
    context "when logged in" do

      before do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        user = FactoryGirl.create(:user)
        sign_in user

        get :index, format: :json
      end

      subject(:current_user) {JSON.parse(response.body)["user"]}

      it 'should have valid response' do
        expect(response).to be_success
        expect(response.status).to eq(200)
      end

      it 'should return valid user' do
        expect(current_user['username']).to eq("Username")
        expect(current_user['email']).to eq("username@service.com")
      end

      it 'should have default avatar' do
        expect(current_user['avatar_file_name']).to eq("/images/medium/missing.png")
      end

      it 'should have zero posts' do
        expect(current_user['posts_count']).to eq(0)
      end

    end

    context "without logging" do

      before do
        get :index, format: :json
      end

      subject(:current_user) {JSON.parse(response.body)["user"]}

      it 'should have valid response' do
        expect(response).to be_success
        expect(response.status).to eq(200)
      end

      it 'should contain null user' do
        expect(current_user).to eq(nil)
      end

    end
  end

  describe "Show action" do
    context "with logging in" do

      before do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        current_user = FactoryGirl.create(:user)
        user = FactoryGirl.create(:other_user)
        sign_in current_user

        get :show, format: :json, id: "Friend"
      end

      subject(:result) {JSON.parse(response.body)}

      it 'should have valid response' do
        expect(response).to be_success
        expect(response.status).to eq(200)
      end

      it 'should display user info' do
        expect(result["user"]["username"]).to eq("Friend")
        expect(result["user"]["email"]).to eq("friend@service.com")
      end

      it 'should not be friend for current user default' do
        expect(result["meta"]["friendship"]).to be_falsy
      end

    end

    context "without logging in" do
      before do
        user = FactoryGirl.create(:other_user)
        get :show, format: :json, id: "Friend"
      end

      subject(:result) {JSON.parse(response.body)}

      it 'should have valid response' do
        expect(response).to be_success
        expect(response.status).to eq(200)
      end

      it 'should display user info' do
        expect(result["user"]["username"]).to eq("Friend")
        expect(result["user"]["email"]).to eq("friend@service.com")
      end

      it 'should display null as friendship' do
        expect(result["meta"]["friendship"]).to be_nil
      end

      it 'should return null user if user doesnt exist' do
        get :show, format: :json, id: "Stranger"
        expect(result["user"]).to be_nil
        expect(result["meta"]["friendship"]).to be_nil
      end

    end
  end

  describe "Update action" do
    context "without logging in" do

      before do
        put :update, format: :json,
          id: "Username",
          user: FactoryGirl.build(:user_with_avatar).attributes
      end

      it 'should return invalid response' do
        expect(response).not_to be_success
        expect(response.status).to eq(401)
      end

    end

    context "with logging in" do

      before do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        @current_user = FactoryGirl.create(:user)
        sign_in @current_user
        @user_avatar = FactoryGirl.build(:user_with_avatar)

        put :update, format: :json,
          id: "Username",
          user: 
          {
            avatar: @user_avatar.avatar
          }
      end

      subject(:result) {JSON.parse(response.body)}

      it 'should return valid response' do
        expect(response).to be_success
        expect(response.status).to eq(200)
      end

      it 'should return current user' do
        expect(result["user"]["username"]).to eq(@current_user.username)
        expect(result["user"]["email"]).to eq(@current_user.email)
      end

      # it 'should return current user with new avatar' do
      #   #binding.pry
      #   saved_file_name = result["user"]["avatar_file_name"].split("/").last
      #   expect(saved_file_name).to eq(@user_avatar.avatar_file_name)
      # end

    end

  end

end

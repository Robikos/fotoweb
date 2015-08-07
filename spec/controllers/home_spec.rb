require 'spec_helper'

describe HomeController, type: :controller do

  it 'should have valid response' do
    get :index
    expect(response).to be_success
    expect(response.status).to eq(200)
  end

end

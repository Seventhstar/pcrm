require 'rails_helper'

RSpec.describe ProvidersController, type: :controller do
  sign_in_user
  let!(:p_statuses) {create_list(:p_status, 5)}

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end


end

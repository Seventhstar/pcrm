require 'rails_helper'

RSpec.describe ProjectStatusController, type: :controller do

  describe "GET #name" do
    it "returns http success" do
      get :name
      expect(response).to have_http_status(:success)
    end
  end

end

require 'rails_helper'

RSpec.describe "Costings", type: :request do
  describe "GET /costings" do
    it "works! (now write some real specs)" do
      get costings_path
      expect(response).to have_http_status(200)
    end
  end
end

require 'rails_helper'

RSpec.describe "Tarifs", type: :request do
  describe "GET /tarifs" do
    it "works! (now write some real specs)" do
      get tarifs_path
      expect(response).to have_http_status(200)
    end
  end
end

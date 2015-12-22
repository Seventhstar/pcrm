require 'rails_helper'

RSpec.describe "Absences", type: :request do
  describe "GET /absences" do
    it "works! (now write some real specs)" do
      get absences_path
      expect(response).to have_http_status(200)
    end
  end
end

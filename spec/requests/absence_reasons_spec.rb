require 'rails_helper'

RSpec.describe "AbsenceReasons", type: :request do
  describe "GET /absence_reasons" do
    it "works! (now write some real specs)" do
      get absence_reasons_path
      expect(response).to have_http_status(200)
    end
  end
end

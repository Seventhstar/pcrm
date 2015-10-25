require 'rails_helper'

RSpec.describe "WikiRecords", type: :request do
  describe "GET /wiki_records" do
    it "works! (now write some real specs)" do
      get wiki_records_path
      expect(response).to have_http_status(200)
    end
  end
end

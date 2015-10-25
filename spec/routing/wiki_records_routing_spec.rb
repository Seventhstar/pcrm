require "rails_helper"

RSpec.describe WikiRecordsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/wiki_records").to route_to("wiki_records#index")
    end

    it "routes to #new" do
      expect(:get => "/wiki_records/new").to route_to("wiki_records#new")
    end

    it "routes to #show" do
      expect(:get => "/wiki_records/1").to route_to("wiki_records#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/wiki_records/1/edit").to route_to("wiki_records#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/wiki_records").to route_to("wiki_records#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/wiki_records/1").to route_to("wiki_records#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/wiki_records/1").to route_to("wiki_records#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/wiki_records/1").to route_to("wiki_records#destroy", :id => "1")
    end

  end
end

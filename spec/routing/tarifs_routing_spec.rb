require "rails_helper"

RSpec.describe TarifsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/tarifs").to route_to("tarifs#index")
    end

    it "routes to #new" do
      expect(:get => "/tarifs/new").to route_to("tarifs#new")
    end

    it "routes to #show" do
      expect(:get => "/tarifs/1").to route_to("tarifs#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/tarifs/1/edit").to route_to("tarifs#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/tarifs").to route_to("tarifs#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/tarifs/1").to route_to("tarifs#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/tarifs/1").to route_to("tarifs#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/tarifs/1").to route_to("tarifs#destroy", :id => "1")
    end

  end
end

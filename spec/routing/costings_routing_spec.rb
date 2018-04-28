require "rails_helper"

RSpec.describe CostingsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/costings").to route_to("costings#index")
    end

    it "routes to #new" do
      expect(:get => "/costings/new").to route_to("costings#new")
    end

    it "routes to #show" do
      expect(:get => "/costings/1").to route_to("costings#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/costings/1/edit").to route_to("costings#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/costings").to route_to("costings#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/costings/1").to route_to("costings#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/costings/1").to route_to("costings#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/costings/1").to route_to("costings#destroy", :id => "1")
    end

  end
end

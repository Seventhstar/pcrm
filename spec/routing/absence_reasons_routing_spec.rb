require "rails_helper"

RSpec.describe AbsenceReasonsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/absence_reasons").to route_to("absence_reasons#index")
    end

    it "routes to #new" do
      expect(:get => "/absence_reasons/new").to route_to("absence_reasons#new")
    end

    it "routes to #show" do
      expect(:get => "/absence_reasons/1").to route_to("absence_reasons#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/absence_reasons/1/edit").to route_to("absence_reasons#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/absence_reasons").to route_to("absence_reasons#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/absence_reasons/1").to route_to("absence_reasons#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/absence_reasons/1").to route_to("absence_reasons#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/absence_reasons/1").to route_to("absence_reasons#destroy", :id => "1")
    end

  end
end

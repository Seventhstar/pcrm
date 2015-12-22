require "rails_helper"

RSpec.describe AbsencesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/absences").to route_to("absences#index")
    end

    it "routes to #new" do
      expect(:get => "/absences/new").to route_to("absences#new")
    end

    it "routes to #show" do
      expect(:get => "/absences/1").to route_to("absences#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/absences/1/edit").to route_to("absences#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/absences").to route_to("absences#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/absences/1").to route_to("absences#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/absences/1").to route_to("absences#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/absences/1").to route_to("absences#destroy", :id => "1")
    end

  end
end

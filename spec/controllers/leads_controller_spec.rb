require 'rails_helper'

RSpec.describe LeadsController, type: :controller do
  # This should return the minimal set of attributes required to create a valid
  # Lead. As you add validations to Lead, be sure to
  # adjust the attributes here as well.
  # let(:valid_attributes) {
  #   #skip("Add a hash of attributes valid for your model")
  #   {info: 'new lead', channel_id: 3}
  # }
  # let(:invalid_attributes) {
  #   skip("Add a hash of attributes invalid for your model")
  # }
  # let(:user1) { create(:user) }
  # let(:user) { create(:user) }
  # before do 
  #   log_in user
  #   puts user1 
  #  end
  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # LeadsController. Be sure to keep this updated too.
  # let(:valid_session) { {} }

  describe "GET #index" do
    let(:user) {create(:user) }
    let(:leads) {create_list(:lead, 2, ic_user: user)}

    # it "assigns all leads as @leads" do
      # lead = Lead.create! valid_attributes
      # get :index, params: {sort: 'status_date', direction: 'asc', sort2: 'status_date', dir2: 'asc', only_actual: true}
      
      # p assigns(:leads)
      # expect(assigns(:leads)).to eq([lead])
      # expect { post :create, params: { info: 'new lead', } }.to change(question.comments, :count).by(1)

      # before {get :index}

      it 'populates an array of all questions' do
        expect(assigns(:leads)).to match_array(leads)
      end

    # end
  end

  # describe "GET #show" do
  #   it "assigns the requested lead as @lead" do
  #     lead = Lead.create! valid_attributes
  #     get :show, {:id => lead.to_param}, valid_session
  #     expect(assigns(:lead)).to eq(lead)
  #   end
  # end

  # describe "GET #new" do
  #   it "assigns a new lead as @lead" do
  #     get :new, {}, valid_session
  #     expect(assigns(:lead)).to be_a_new(Lead)
  #   end
  # end

  # describe "GET #edit" do
  #   it "assigns the requested lead as @lead" do
  #     lead = Lead.create! valid_attributes
  #     get :edit, {:id => lead.to_param}, valid_session
  #     expect(assigns(:lead)).to eq(lead)
  #   end
  # end

  # describe "POST #create" do
  #   context "with valid params" do
  #     it "creates a new Lead" do
  #       expect {
  #         post :create, {:lead => valid_attributes}, valid_session
  #       }.to change(Lead, :count).by(1)
  #     end

  #     it "assigns a newly created lead as @lead" do
  #       post :create, {:lead => valid_attributes}, valid_session
  #       expect(assigns(:lead)).to be_a(Lead)
  #       expect(assigns(:lead)).to be_persisted
  #     end

  #     it "redirects to the created lead" do
  #       post :create, {:lead => valid_attributes}, valid_session
  #       expect(response).to redirect_to(leads_url)
  #     end
  #   end

  #   context "with invalid params" do
  #     it "assigns a newly created but unsaved lead as @lead" do
  #       post :create, {:lead => invalid_attributes}, valid_session
  #       expect(assigns(:lead)).to be_a_new(Lead)
  #     end

  #     it "re-renders the 'new' template" do
  #       post :create, {:lead => invalid_attributes}, valid_session
  #       expect(response).to render_template("new")
  #     end
  #   end
  # end

  # describe "PUT #update" do
  #   context "with valid params" do
  #     let(:new_attributes) {
  #       skip("Add a hash of attributes valid for your model")
  #     }

  #     it "updates the requested lead" do
  #       lead = Lead.create! valid_attributes
  #       put :update, {:id => lead.to_param, :lead => new_attributes}, valid_session
  #       lead.reload
  #       skip("Add assertions for updated state")
  #     end

  #     it "assigns the requested lead as @lead" do
  #       lead = Lead.create! valid_attributes
  #       put :update, {:id => lead.to_param, :lead => valid_attributes}, valid_session
  #       expect(assigns(:lead)).to eq(lead)
  #     end

  #     it "redirects to the lead" do
  #       lead = Lead.create! valid_attributes
  #       put :update, {:id => lead.to_param, :lead => valid_attributes}, valid_session
  #       expect(response).to redirect_to(leads_url)
  #     end
  #   end

  #   context "with invalid params" do
  #     it "assigns the lead as @lead" do
  #       lead = Lead.create! valid_attributes
  #       put :update, {:id => lead.to_param, :lead => invalid_attributes}, valid_session
  #       expect(assigns(:lead)).to eq(lead)
  #     end

  #     it "re-renders the 'edit' template" do
  #       lead = Lead.create! valid_attributes
  #       put :update, {:id => lead.to_param, :lead => invalid_attributes}, valid_session
  #       expect(response).to render_template("edit")
  #     end
  #   end
  # end

  # describe "DELETE #destroy" do
  #   it "destroys the requested lead" do
  #     lead = Lead.create! valid_attributes
  #     expect {
  #       delete :destroy, {:id => lead.to_param}, valid_session
  #     }.to change(Lead, :count).by(-1)
  #   end

  #   it "redirects to the leads list" do
  #     lead = Lead.create! valid_attributes
  #     delete :destroy, {:id => lead.to_param}, valid_session
  #     expect(response).to redirect_to(leads_url)
  #   end
  # end

end

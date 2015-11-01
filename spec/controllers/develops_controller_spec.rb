require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe DevelopsController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Develop. As you add validations to Develop, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    #skip("Add a hash of attributes valid for your model")
    {name: 'new develop'}
  }

  let(:invalid_attributes) {
    #skip("Add a hash of attributes invalid for your model")
    {name: nil}
  }

  let(:user1) { User.first }
  before do 
   log_in user1 
  #p user1 
 end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # DevelopsController. Be sure to keep this updated too.
  #let(:valid_session) { {} }

  describe "GET #index" do
    it "assigns all Develops as @Develops" do
      log_in user1
      develop = Develop.create! valid_attributes
      get :index
      p [develop]
      p "assigns(:develops)", assigns(:develops)
      expect(assigns(:develops).to_a).to eq([develop])
    end
  end

  describe "GET #show" do
    it "assigns the requested Develop as @Develop" do
      develop = Develop.create! valid_attributes
      get :show, {:id => develop.to_param}
      expect(assigns(:develop)).to eq(develop)
    end
  end

  describe "GET #new" do
    it "assigns a new Develop as @Develop" do
      get :new, {}
      #p Develop
      #p assigns(:develop)
      expect(assigns(:develop)).to be_a_new(Develop)
    end
  end

  describe "GET #edit" do
    it "assigns the requested Develop as @Develop" do
      develop = Develop.create! valid_attributes
      get :edit, {:id => develop.to_param}
      expect(assigns(:develop)).to eq(develop)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Develop" do
        expect {
          post :create, {:develop => valid_attributes}
        }.to change(Develop, :count).by(1)
      end

      it "assigns a newly created Develop as @Develop" do
        post :create, {:develop => valid_attributes}
        expect(assigns(:develop)).to be_a(Develop)
        expect(assigns(:develop)).to be_persisted
      end

      it "redirects to the created Develop" do
        post :create, {:develop => valid_attributes}
        expect(response).to redirect_to(develops_url)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved Develop as @Develop" do
        post :create, {:develop => invalid_attributes}
        expect(assigns(:develop)).to be_a_new(Develop)
      end

      it "re-renders the 'new' template" do
        post :create, {:develop => invalid_attributes}
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        #skip("Add a hash of attributes valid for your model")
        {name: 'new dev'}
      }

      it "updates the requested Develop" do
        develop = Develop.create! valid_attributes
        put :update, {:id => develop.to_param, :develop => new_attributes}
        develop.reload
        #skip("Add assertions for updated state")
        expect(develop.attributes).to include( { "name" => 'new dev' } )
      end

      it "assigns the requested Develop as @Develop" do
        develop = Develop.create! valid_attributes
        put :update, {:id => develop.to_param, :develop => valid_attributes}
        expect(assigns(:develop)).to eq(develop)
      end

      it "redirects to the Develop" do
        develop = Develop.create! valid_attributes
        put :update, {:id => develop.to_param, :develop => valid_attributes}
        expect(response).to redirect_to(develops_url)
      end
    end

    context "with invalid params" do
      it "assigns the Develop as @Develop" do
        develop = Develop.create! valid_attributes
        put :update, {:id => develop.to_param, :develop => invalid_attributes}
        expect(assigns(:develop)).to eq(develop)
      end

      it "re-renders the 'edit' template" do
        develop = Develop.create! valid_attributes
        put :update, {:id => develop.to_param, :develop => invalid_attributes}
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested Develop" do
      develop = Develop.create! valid_attributes
      expect {
        delete :destroy, {:id => develop.to_param}
      }.to change(Develop, :count).by(-1)
    end

    it "redirects to the Develops list" do
      develop = Develop.create! valid_attributes
      delete :destroy, {:id => develop.to_param}
      expect(response).to redirect_to(develops_url)
    end
  end

end

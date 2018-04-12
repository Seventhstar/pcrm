require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  sign_in_user
  let(:client) {create  :client}
  let(:user) {create :user}

  describe 'POST #create' do
    context 'with valid attributes' do
      let(:projects) {create_list(:project, 2)}

      it 'saves new answer to the DB' do
        p "user: #{user}"
        expect {post :create, params: {project: {address: 'wjehj', client_id: client.id, executor_id: user.id }}}.to change(projects, :count).by(1)
      end

      # it 'redirects to show view of a question' do
      #   post :create, params: {question_id: question, answer: attributes_for(:answer), format: :js}
      # end
    end
  end

end

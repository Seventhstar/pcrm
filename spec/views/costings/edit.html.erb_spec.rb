require 'rails_helper'

RSpec.describe "costings/edit", type: :view do
  before(:each) do
    @costing = assign(:costing, Costing.create!(
      :project => nil,
      :user => nil
    ))
  end

  it "renders the edit costing form" do
    render

    assert_select "form[action=?][method=?]", costing_path(@costing), "post" do

      assert_select "input[name=?]", "costing[project_id]"

      assert_select "input[name=?]", "costing[user_id]"
    end
  end
end

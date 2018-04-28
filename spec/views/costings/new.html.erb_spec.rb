require 'rails_helper'

RSpec.describe "costings/new", type: :view do
  before(:each) do
    assign(:costing, Costing.new(
      :project => nil,
      :user => nil
    ))
  end

  it "renders new costing form" do
    render

    assert_select "form[action=?][method=?]", costings_path, "post" do

      assert_select "input[name=?]", "costing[project_id]"

      assert_select "input[name=?]", "costing[user_id]"
    end
  end
end

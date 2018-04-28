require 'rails_helper'

RSpec.describe "costings/index", type: :view do
  before(:each) do
    assign(:costings, [
      Costing.create!(
        :project => nil,
        :user => nil
      ),
      Costing.create!(
        :project => nil,
        :user => nil
      )
    ])
  end

  it "renders a list of costings" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end

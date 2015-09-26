require 'rails_helper'

RSpec.describe "receipts/index", type: :view do
  before(:each) do
    assign(:receipts, [
      Receipt.create!(
        :project_id => 1,
        :user_id => 2,
        :provider_id => 3,
        :payment_type_id => 4,
        :sum => 5,
        :description => "Description"
      ),
      Receipt.create!(
        :project_id => 1,
        :user_id => 2,
        :provider_id => 3,
        :payment_type_id => 4,
        :sum => 5,
        :description => "Description"
      )
    ])
  end

  it "renders a list of receipts" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
  end
end

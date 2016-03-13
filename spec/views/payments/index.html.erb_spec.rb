require 'rails_helper'

RSpec.describe "payments/index", type: :view do
  before(:each) do
    assign(:payments, [
      Payment.create!(
        :project_id => 1,
        :user_id => 2,
        :whom_id => 3,
        :whom_type => "Whom Type",
        :payment_type_id => 4,
        :payment_purpose_id => 5,
        :sum => 6,
        :verified. => false,
        :description => "Description"
      ),
      Payment.create!(
        :project_id => 1,
        :user_id => 2,
        :whom_id => 3,
        :whom_type => "Whom Type",
        :payment_type_id => 4,
        :payment_purpose_id => 5,
        :sum => 6,
        :verified. => false,
        :description => "Description"
      )
    ])
  end

  it "renders a list of payments" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => "Whom Type".to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
    assert_select "tr>td", :text => 6.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
  end
end

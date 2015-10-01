require 'rails_helper'

RSpec.describe "receipts/edit", type: :view do
  before(:each) do
    @receipt = assign(:receipt, Receipt.create!(
      :project_id => 1,
      :user_id => 1,
      :provider_id => 1,
      :payment_type_id => 1,
      :sum => 1,
      :description => "MyString"
    ))
  end

  it "renders the edit receipt form" do
    render

    assert_select "form[action=?][method=?]", receipt_path(@receipt), "post" do

      assert_select "input#receipt_project_id[name=?]", "receipt[project_id]"

      assert_select "input#receipt_user_id[name=?]", "receipt[user_id]"

      assert_select "input#receipt_provider_id[name=?]", "receipt[provider_id]"

      assert_select "input#receipt_payment_type_id[name=?]", "receipt[payment_type_id]"

      assert_select "input#receipt_sum[name=?]", "receipt[sum]"

      assert_select "input#receipt_description[name=?]", "receipt[description]"
    end
  end
end
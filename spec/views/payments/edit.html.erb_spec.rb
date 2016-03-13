require 'rails_helper'

RSpec.describe "payments/edit", type: :view do
  before(:each) do
    @payment = assign(:payment, Payment.create!(
      :project_id => 1,
      :user_id => 1,
      :whom_id => 1,
      :whom_type => "MyString",
      :payment_type_id => 1,
      :payment_purpose_id => 1,
      :sum => 1,
      :verified. => false,
      :description => "MyString"
    ))
  end

  it "renders the edit payment form" do
    render

    assert_select "form[action=?][method=?]", payment_path(@payment), "post" do

      assert_select "input#payment_project_id[name=?]", "payment[project_id]"

      assert_select "input#payment_user_id[name=?]", "payment[user_id]"

      assert_select "input#payment_whom_id[name=?]", "payment[whom_id]"

      assert_select "input#payment_whom_type[name=?]", "payment[whom_type]"

      assert_select "input#payment_payment_type_id[name=?]", "payment[payment_type_id]"

      assert_select "input#payment_payment_purpose_id[name=?]", "payment[payment_purpose_id]"

      assert_select "input#payment_sum[name=?]", "payment[sum]"

      assert_select "input#payment_verified.[name=?]", "payment[verified.]"

      assert_select "input#payment_description[name=?]", "payment[description]"
    end
  end
end

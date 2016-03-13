require 'rails_helper'

RSpec.describe "payments/show", type: :view do
  before(:each) do
    @payment = assign(:payment, Payment.create!(
      :project_id => 1,
      :user_id => 2,
      :whom_id => 3,
      :whom_type => "Whom Type",
      :payment_type_id => 4,
      :payment_purpose_id => 5,
      :sum => 6,
      :verified. => false,
      :description => "Description"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/Whom Type/)
    expect(rendered).to match(/4/)
    expect(rendered).to match(/5/)
    expect(rendered).to match(/6/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/Description/)
  end
end

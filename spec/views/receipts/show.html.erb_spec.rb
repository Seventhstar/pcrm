require 'rails_helper'

RSpec.describe "receipts/show", type: :view do
  before(:each) do
    @receipt = assign(:receipt, Receipt.create!(
      :project_id => 1,
      :user_id => 2,
      :provider_id => 3,
      :payment_type_id => 4,
      :sum => 5,
      :description => "Description"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/4/)
    expect(rendered).to match(/5/)
    expect(rendered).to match(/Description/)
  end
end

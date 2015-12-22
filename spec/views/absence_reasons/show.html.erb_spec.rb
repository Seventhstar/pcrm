require 'rails_helper'

RSpec.describe "absence_reasons/show", type: :view do
  before(:each) do
    @absence_reason = assign(:absence_reason, AbsenceReason.create!(
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
  end
end

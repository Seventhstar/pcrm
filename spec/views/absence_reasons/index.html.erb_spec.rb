require 'rails_helper'

RSpec.describe "absence_reasons/index", type: :view do
  before(:each) do
    assign(:absence_reasons, [
      AbsenceReason.create!(
        :name => "Name"
      ),
      AbsenceReason.create!(
        :name => "Name"
      )
    ])
  end

  it "renders a list of absence_reasons" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end

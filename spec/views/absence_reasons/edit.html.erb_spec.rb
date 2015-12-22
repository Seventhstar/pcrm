require 'rails_helper'

RSpec.describe "absence_reasons/edit", type: :view do
  before(:each) do
    @absence_reason = assign(:absence_reason, AbsenceReason.create!(
      :name => "MyString"
    ))
  end

  it "renders the edit absence_reason form" do
    render

    assert_select "form[action=?][method=?]", absence_reason_path(@absence_reason), "post" do

      assert_select "input#absence_reason_name[name=?]", "absence_reason[name]"
    end
  end
end

require 'rails_helper'

RSpec.describe "absences/edit", type: :view do
  before(:each) do
    @absence = assign(:absence, Absence.create!(
      :user_id => 1,
      :reason_id => 1,
      :new_reason_id => 1,
      :comment => "MyText",
      :project_id => 1
    ))
  end

  it "renders the edit absence form" do
    render

    assert_select "form[action=?][method=?]", absence_path(@absence), "post" do

      assert_select "input#absence_user_id[name=?]", "absence[user_id]"

      assert_select "input#absence_reason_id[name=?]", "absence[reason_id]"

      assert_select "input#absence_new_reason_id[name=?]", "absence[new_reason_id]"

      assert_select "textarea#absence_comment[name=?]", "absence[comment]"

      assert_select "input#absence_project_id[name=?]", "absence[project_id]"
    end
  end
end

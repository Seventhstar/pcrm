require 'rails_helper'

RSpec.describe "absences/index", type: :view do
  before(:each) do
    assign(:absences, [
      Absence.create!(
        :user_id => 1,
        :reason_id => 2,
        :new_reason_id => 3,
        :comment => "MyText",
        :project_id => 4
      ),
      Absence.create!(
        :user_id => 1,
        :reason_id => 2,
        :new_reason_id => 3,
        :comment => "MyText",
        :project_id => 4
      )
    ])
  end

  it "renders a list of absences" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
  end
end

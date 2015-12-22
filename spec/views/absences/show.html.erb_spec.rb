require 'rails_helper'

RSpec.describe "absences/show", type: :view do
  before(:each) do
    @absence = assign(:absence, Absence.create!(
      :user_id => 1,
      :reason_id => 2,
      :new_reason_id => 3,
      :comment => "MyText",
      :project_id => 4
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/4/)
  end
end

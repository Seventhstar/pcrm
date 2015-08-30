require 'rails_helper'

RSpec.describe "projects/show", type: :view do
  before(:each) do
    @project = assign(:project, Project.create!(
      :client_id => 1,
      :address => "Address",
      :owner_id => 2,
      :executor_id => 3,
      :designer_id => 4,
      :project_type_id => 5,
      :number => 6,
      :footage => 1.5,
      :footage2 => 1.5,
      :footage_real => 1.5,
      :footage2_real => 1.5,
      :style_id => 7,
      :sum => 8,
      :sum_real => 9,
      :price_m => 10,
      :price_2 => 11,
      :price_real_m => 12,
      :price_real_2 => 13,
      :month_in_gift => 14,
      :act => false,
      :delay_days => 15
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Address/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/4/)
    expect(rendered).to match(/5/)
    expect(rendered).to match(/6/)
    expect(rendered).to match(/1.5/)
    expect(rendered).to match(/1.5/)
    expect(rendered).to match(/1.5/)
    expect(rendered).to match(/1.5/)
    expect(rendered).to match(/7/)
    expect(rendered).to match(/8/)
    expect(rendered).to match(/9/)
    expect(rendered).to match(/10/)
    expect(rendered).to match(/11/)
    expect(rendered).to match(/12/)
    expect(rendered).to match(/13/)
    expect(rendered).to match(/14/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/15/)
  end
end

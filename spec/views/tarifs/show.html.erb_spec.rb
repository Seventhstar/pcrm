require 'rails_helper'

RSpec.describe "tarifs/show", type: :view do
  before(:each) do
    @tarif = assign(:tarif, Tarif.create!(
      :project_type => nil,
      :sum => 2,
      :sum2 => 3,
      :tarif_calc_type => nil,
      :from => 4,
      :dis_price => 5,
      :dis_price2 => 6,
      :vis_price => 7
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(//)
    expect(rendered).to match(/4/)
    expect(rendered).to match(/5/)
    expect(rendered).to match(/6/)
    expect(rendered).to match(/7/)
  end
end

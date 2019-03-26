require 'rails_helper'

RSpec.describe "tarifs/index", type: :view do
  before(:each) do
    assign(:tarifs, [
      Tarif.create!(
        :project_type => nil,
        :sum => 2,
        :sum2 => 3,
        :tarif_calc_type => nil,
        :from => 4,
        :dis_price => 5,
        :dis_price2 => 6,
        :vis_price => 7
      ),
      Tarif.create!(
        :project_type => nil,
        :sum => 2,
        :sum2 => 3,
        :tarif_calc_type => nil,
        :from => 4,
        :dis_price => 5,
        :dis_price2 => 6,
        :vis_price => 7
      )
    ])
  end

  it "renders a list of tarifs" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
    assert_select "tr>td", :text => 6.to_s, :count => 2
    assert_select "tr>td", :text => 7.to_s, :count => 2
  end
end

require 'rails_helper'

RSpec.describe "projects/index", type: :view do
  before(:each) do
    assign(:projects, [
      Project.create!(
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
      ),
      Project.create!(
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
      )
    ])
  end

  it "renders a list of projects" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Address".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
    assert_select "tr>td", :text => 6.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 7.to_s, :count => 2
    assert_select "tr>td", :text => 8.to_s, :count => 2
    assert_select "tr>td", :text => 9.to_s, :count => 2
    assert_select "tr>td", :text => 10.to_s, :count => 2
    assert_select "tr>td", :text => 11.to_s, :count => 2
    assert_select "tr>td", :text => 12.to_s, :count => 2
    assert_select "tr>td", :text => 13.to_s, :count => 2
    assert_select "tr>td", :text => 14.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => 15.to_s, :count => 2
  end
end

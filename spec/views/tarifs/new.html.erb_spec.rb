require 'rails_helper'

RSpec.describe "tarifs/new", type: :view do
  before(:each) do
    assign(:tarif, Tarif.new(
      :project_type => nil,
      :sum => 1,
      :sum2 => 1,
      :tarif_calc_type => nil,
      :from => 1,
      :dis_price => 1,
      :dis_price2 => 1,
      :vis_price => 1
    ))
  end

  it "renders new tarif form" do
    render

    assert_select "form[action=?][method=?]", tarifs_path, "post" do

      assert_select "input[name=?]", "tarif[project_type_id]"

      assert_select "input[name=?]", "tarif[sum]"

      assert_select "input[name=?]", "tarif[sum2]"

      assert_select "input[name=?]", "tarif[tarif_calc_type_id]"

      assert_select "input[name=?]", "tarif[from]"

      assert_select "input[name=?]", "tarif[dis_price]"

      assert_select "input[name=?]", "tarif[dis_price2]"

      assert_select "input[name=?]", "tarif[vis_price]"
    end
  end
end
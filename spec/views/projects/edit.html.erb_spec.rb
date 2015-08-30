require 'rails_helper'

RSpec.describe "projects/edit", type: :view do
  before(:each) do
    @project = assign(:project, Project.create!(
      :client_id => 1,
      :address => "MyString",
      :owner_id => 1,
      :executor_id => 1,
      :designer_id => 1,
      :project_type_id => 1,
      :number => 1,
      :footage => 1.5,
      :footage2 => 1.5,
      :footage_real => 1.5,
      :footage2_real => 1.5,
      :style_id => 1,
      :sum => 1,
      :sum_real => 1,
      :price_m => 1,
      :price_2 => 1,
      :price_real_m => 1,
      :price_real_2 => 1,
      :month_in_gift => 1,
      :act => false,
      :delay_days => 1
    ))
  end

  it "renders the edit project form" do
    render

    assert_select "form[action=?][method=?]", project_path(@project), "post" do

      assert_select "input#project_client_id[name=?]", "project[client_id]"

      assert_select "input#project_address[name=?]", "project[address]"

      assert_select "input#project_owner_id[name=?]", "project[owner_id]"

      assert_select "input#project_executor_id[name=?]", "project[executor_id]"

      assert_select "input#project_designer_id[name=?]", "project[designer_id]"

      assert_select "input#project_project_type_id[name=?]", "project[project_type_id]"

      assert_select "input#project_number[name=?]", "project[number]"

      assert_select "input#project_footage[name=?]", "project[footage]"

      assert_select "input#project_footage2[name=?]", "project[footage2]"

      assert_select "input#project_footage_real[name=?]", "project[footage_real]"

      assert_select "input#project_footage2_real[name=?]", "project[footage2_real]"

      assert_select "input#project_style_id[name=?]", "project[style_id]"

      assert_select "input#project_sum[name=?]", "project[sum]"

      assert_select "input#project_sum_real[name=?]", "project[sum_real]"

      assert_select "input#project_price_m[name=?]", "project[price_m]"

      assert_select "input#project_price_2[name=?]", "project[price_2]"

      assert_select "input#project_price_real_m[name=?]", "project[price_real_m]"

      assert_select "input#project_price_real_2[name=?]", "project[price_real_2]"

      assert_select "input#project_month_in_gift[name=?]", "project[month_in_gift]"

      assert_select "input#project_act[name=?]", "project[act]"

      assert_select "input#project_delay_days[name=?]", "project[delay_days]"
    end
  end
end

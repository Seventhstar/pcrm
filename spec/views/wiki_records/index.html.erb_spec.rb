require 'rails_helper'

RSpec.describe "wiki_records/index", type: :view do
  before(:each) do
    assign(:wiki_records, [
      WikiRecord.create!(
        :name => "Name",
        :description => "MyText",
        :parent_id => 1
      ),
      WikiRecord.create!(
        :name => "Name",
        :description => "MyText",
        :parent_id => 1
      )
    ])
  end

  it "renders a list of wiki_records" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end

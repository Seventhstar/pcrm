require 'rails_helper'

RSpec.describe "wiki_records/new", type: :view do
  before(:each) do
    assign(:wiki_record, WikiRecord.new(
      :name => "MyString",
      :description => "MyText",
      :parent_id => 1
    ))
  end

  it "renders new wiki_record form" do
    render

    assert_select "form[action=?][method=?]", wiki_records_path, "post" do

      assert_select "input#wiki_record_name[name=?]", "wiki_record[name]"

      assert_select "textarea#wiki_record_description[name=?]", "wiki_record[description]"

      assert_select "input#wiki_record_parent_id[name=?]", "wiki_record[parent_id]"
    end
  end
end

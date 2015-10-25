require 'rails_helper'

RSpec.describe "wiki_records/edit", type: :view do
  before(:each) do
    @wiki_record = assign(:wiki_record, WikiRecord.create!(
      :name => "MyString",
      :description => "MyText",
      :parent_id => 1
    ))
  end

  it "renders the edit wiki_record form" do
    render

    assert_select "form[action=?][method=?]", wiki_record_path(@wiki_record), "post" do

      assert_select "input#wiki_record_name[name=?]", "wiki_record[name]"

      assert_select "textarea#wiki_record_description[name=?]", "wiki_record[description]"

      assert_select "input#wiki_record_parent_id[name=?]", "wiki_record[parent_id]"
    end
  end
end

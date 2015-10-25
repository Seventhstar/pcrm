require 'rails_helper'

RSpec.describe "wiki_records/show", type: :view do
  before(:each) do
    @wiki_record = assign(:wiki_record, WikiRecord.create!(
      :name => "Name",
      :description => "MyText",
      :parent_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/1/)
  end
end

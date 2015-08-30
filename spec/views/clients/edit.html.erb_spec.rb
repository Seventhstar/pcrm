require 'rails_helper'

RSpec.describe "clients/edit", type: :view do
  before(:each) do
    @client = assign(:client, Client.create!(
      :name => "MyString",
      :address => "MyString",
      :phone => "MyString",
      :email => "MyString"
    ))
  end

  it "renders the edit client form" do
    render

    assert_select "form[action=?][method=?]", client_path(@client), "post" do

      assert_select "input#client_name[name=?]", "client[name]"

      assert_select "input#client_address[name=?]", "client[address]"

      assert_select "input#client_phone[name=?]", "client[phone]"

      assert_select "input#client_email[name=?]", "client[email]"
    end
  end
end

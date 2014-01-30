require 'spec_helper'

describe "authors/edit" do
  before(:each) do
    @author = assign(:author, stub_model(Author,
      :firstname => "MyString",
      :lastname => "MyString"
    ))
  end

  it "renders the edit author form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", author_path(@author), "post" do
      assert_select "input#author_firstname[name=?]", "author[firstname]"
      assert_select "input#author_lastname[name=?]", "author[lastname]"
    end
  end
end

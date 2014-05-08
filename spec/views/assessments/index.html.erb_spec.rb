require 'spec_helper'

describe "assessments/index" do
  it "displays all the assessments" do
    assign(:assessments, [
      stub_model(Assessment, :title => "foo1"),
      stub_model(Assessment, :title => "foo2")
    ])

    render

    expect(rendered).to match /foo1/
    expect(rendered).to match /foo2/
  end
end

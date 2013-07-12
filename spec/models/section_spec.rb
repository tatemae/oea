require 'spec_helper'

describe Section do
  before do
    @xml = open('./spec/fixtures/section.xml').read
    assessment = FactoryGirl.create(:assessment)
    @section = Section.from_xml(@xml, assessment)
  end

  it 'should extract the identifier' do
    @section.identifier.should eq 'S1002'
  end

  it 'should extract the items' do
    @section.items.count.should eq 8
  end
end

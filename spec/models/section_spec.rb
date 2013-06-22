require 'spec_helper'

describe Section do
  before do
    @xml = open('./spec/fixtures/section.xml').read
    @section = Section.new( xml: @xml )
    @section.save!
  end

  it 'should extract the identifier' do
    @section.identifier.should eq 'S1002'
  end

  it 'should extract the identifier' do
    @section.title.should eq 'Main'
  end

  it 'should extract the items' do
    @section.items.count.should eq 1
  end
end

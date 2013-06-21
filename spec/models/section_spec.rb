require 'spec_helper'

describe Section do
  before do
    @xml = open('./spec/fixtures/section.xml')
    @section = Section.new( xml: @xml )
  end

  it 'should extract the identifier' do
    @section.identifier.should match /S1002/
  end

  it 'should extract the identifier' do
    @section.title.should match /Main/
  end
end

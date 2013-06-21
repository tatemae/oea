require 'spec_helper'

describe Assessment do
  before do
    @xml = open('./spec/fixtures/test.xml')
    @assessment = Assessment.new( xml: @xml )
  end

  it 'should extract the identifier' do
    @assessment.identifier.should match /A1001/
  end

  it 'should extract the identifier' do
    @assessment.title.should match /XQuestionSample/
  end
end

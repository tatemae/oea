require 'spec_helper'

describe Assessment do
  before do
    @xml = open('./spec/fixtures/test.xml').read
    @assessment = Assessment.new( xml: @xml )
    @assessment.save!
  end

  it 'should extract the identifier' do
    @assessment.identifier.should match /A1001/
  end

  it 'should extract the identifier' do
    @assessment.title.should match /XQuestionSample/
  end

  it 'should extract the identifier' do
    @assessment.sections.count.should eq 1
  end
end

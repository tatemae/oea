require 'spec_helper'

describe Assessment do
  before do
    @xml = open('./spec/fixtures/test.xml').read
    @assessment = Assessment.new( xml: @xml )
    @assessment.save!
  end

  it 'should extract the identifier' do
    @assessment.identifier.should eq 'A1001'
  end

  it 'should extract the title' do
    @assessment.title.should eq 'XQuestionSample'
  end

  it 'should extract the section' do
    @assessment.sections.count.should eq 1
  end
end

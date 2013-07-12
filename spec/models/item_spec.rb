require 'spec_helper'

describe Item do
  before do
    section = FactoryGirl.create(:section)
    @xml = '<item ident="i4023e1a6889fc13b83d2a6a9991a46d2" title="Question 2"> <itemmetadata> <qtimetadata> <qtimetadatafield> <fieldlabel>question_type</fieldlabel> <fieldentry>multiple_choice_question</fieldentry> </qtimetadatafield> <qtimetadatafield> <fieldlabel>points_possible</fieldlabel> <fieldentry>1</fieldentry> </qtimetadatafield> <qtimetadatafield> <fieldlabel>assessment_question_identifierref</fieldlabel> <fieldentry>ib550dd245ac5e15799afb9245f6548ff</fieldentry> </qtimetadatafield> </qtimetadata> </itemmetadata> <presentation> <material> <mattext texttype="text/html">&lt;div&gt;&lt;p&gt;&lt;img class="equation_image" title="\frac{4}{5}\:?\:\frac{6}{7}" src="https://canvas.instructure.com/equation_images/%255Cfrac%257B4%257D%257B5%257D%255C%253A%253F%255C%253A%255Cfrac%257B6%257D%257B7%257D" alt="\frac{4}{5}\:?\:\frac{6}{7}"&gt;&lt;/p&gt;&lt;/div&gt;</mattext> </material> <response_lid ident="response1" rcardinality="Single"> <render_choice> <response_label ident="1602"> <material> <mattext texttype="text/plain">Greater than (&gt;)</mattext> </material> </response_label> <response_label ident="8292"> <material> <mattext texttype="text/plain">Less than (&lt;)</mattext> </material> </response_label> <response_label ident="2753"> <material> <mattext texttype="text/plain">Equivalent (=)</mattext> </material> </response_label> </render_choice> </response_lid> </presentation> <resprocessing> <outcomes> <decvar maxvalue="100" minvalue="0" varname="SCORE" vartype="Decimal"/> </outcomes> <respcondition continue="No"> <conditionvar> <varequal respident="response1">1602</varequal> </conditionvar> <setvar action="Set" varname="SCORE">100</setvar> </respcondition> </resprocessing> </item>'
    @item = Item.from_xml(@xml, section)
  end

  # it { should have_many :item_results }

  it 'should extract the question_text' do
    @item.question_text.should match /<div.*<\/div>/
  end

  it 'should extract an array of answers' do
    @item.get_answers.count.should == 3
  end

  it 'should create and answer with an id' do
    @item.get_answers.first.id.should == '1602'
  end

  it 'should create an answer with the answer text' do
    @item.get_answers.first.text.should match /Greater than \(>\)/
  end

  it 'should respond true if the response is correct' do
    @item.is_correct?('1602').should be_true
  end

  it 'should extract the question_type' do
    @item.base_type.should match 'multiple_choice_question'
  end
end

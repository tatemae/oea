require 'spec_helper'

describe Item do
  before do
    @xml = '<item ident="i4023e1a6889fc13b83d2a6a9991a46d2" title="Question 2"> <itemmetadata> <qtimetadata> <qtimetadatafield> <fieldlabel>question_type</fieldlabel> <fieldentry>multiple_choice_question</fieldentry> </qtimetadatafield> <qtimetadatafield> <fieldlabel>points_possible</fieldlabel> <fieldentry>1</fieldentry> </qtimetadatafield> <qtimetadatafield> <fieldlabel>assessment_question_identifierref</fieldlabel> <fieldentry>ib550dd245ac5e15799afb9245f6548ff</fieldentry> </qtimetadatafield> </qtimetadata> </itemmetadata> <presentation> <material> <mattext texttype="text/html">&lt;div&gt;&lt;p&gt;&lt;img class="equation_image" title="\frac{4}{5}\:?\:\frac{6}{7}" src="https://canvas.instructure.com/equation_images/%255Cfrac%257B4%257D%257B5%257D%255C%253A%253F%255C%253A%255Cfrac%257B6%257D%257B7%257D" alt="\frac{4}{5}\:?\:\frac{6}{7}"&gt;&lt;/p&gt;&lt;/div&gt;</mattext> </material> <response_lid ident="response1" rcardinality="Single"> <render_choice> <response_label ident="1602"> <material> <mattext texttype="text/plain">Greater than (&gt;)</mattext> </material> </response_label> <response_label ident="8292"> <material> <mattext texttype="text/plain">Less than (&lt;)</mattext> </material> </response_label> <response_label ident="2753"> <material> <mattext texttype="text/plain">Equivalent (=)</mattext> </material> </response_label> </render_choice> </response_lid> </presentation> <resprocessing> <outcomes> <decvar maxvalue="100" minvalue="0" varname="SCORE" vartype="Decimal"/> </outcomes> <respcondition continue="No"> <conditionvar> <varequal respident="response1">1602</varequal> </conditionvar> <setvar action="Set" varname="SCORE">100</setvar> </respcondition> </resprocessing> </item>'
    @item = Item.new( xml: @xml )
    @item_result = ItemResult.new(
      :identifier => @item.identifier,
        :item_id => @item.id,
        :rendered_datestamp => Time.now-1,
        :datestamp => Time.now,
        :referer => 'http://localhost:3000/items',
        :ip_address => "127.0.0.1",
        :session_status => "final")
  end

  # it { should belong_to :item }
  # it { should belong_to :user }

  it "should allow session_status to be set to 'initial'" do
    @item_result.session_status = 'initial'
    @item_result.save!.should be_true
  end

  it "should allow session_status to be set to 'pendingSubmission'" do
    @item_result.session_status = 'pendingSubmission'
    @item_result.save!.should be_true
  end

  it "should allow session_status to be set to 'pendingResponseProcessing'" do
    @item_result.session_status = 'pendingResponseProcessing'
    @item_result.save!.should be_true
  end

  it "should allow session_status to be set to 'final'" do
    @item_result.session_status = 'final'
    @item_result.save!.should be_true
  end

  it "should NOT allow session_status to be set to 'initialzzzz'" do
    @item_result.session_status = 'initialzzzz'
    expect { @item_result.save! }.to raise_error("Not a valid session status.")
  end

  it "should NOT allow session_status to be set to 'pendingSubmissionzzzz'" do
    @item_result.session_status = 'pendingSubmissionzzzz'
    expect { @item_result.save! }.to raise_error("Not a valid session status.")
  end

  it "should NOT allow session_status to be set to 'pendingResponseProcessingzzzz'" do
    @item_result.session_status = 'pendingResponseProcessingzzzz'
    expect { @item_result.save! }.to raise_error("Not a valid session status.")
  end

  it "should NOT allow session_status to be set to 'finalzzzz'" do
    @item_result.session_status = 'finalzzzz'
    expect { @item_result.save! }.to raise_error("Not a valid session status.")
  end

end
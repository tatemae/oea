require 'spec_helper'

describe Item do
  describe 'item' do
    before do
      @section = FactoryGirl.create(:section)
      identifier = FactoryGirl.generate(:name)
      @xml = '<item ident="' + identifier + '" title="Question 2"> <itemmetadata> <qtimetadata> <qtimetadatafield> <fieldlabel>question_type</fieldlabel> <fieldentry>multiple_choice_question</fieldentry> </qtimetadatafield> <qtimetadatafield> <fieldlabel>points_possible</fieldlabel> <fieldentry>1</fieldentry> </qtimetadatafield> <qtimetadatafield> <fieldlabel>assessment_question_identifierref</fieldlabel> <fieldentry>ib550dd245ac5e15799afb9245f6548ff</fieldentry> </qtimetadatafield> </qtimetadata> </itemmetadata> <presentation> <material> <mattext texttype="text/html">&lt;div&gt;&lt;p&gt;&lt;img class="equation_image" title="\frac{4}{5}\:?\:\frac{6}{7}" src="https://canvas.instructure.com/equation_images/%255Cfrac%257B4%257D%257B5%257D%255C%253A%253F%255C%253A%255Cfrac%257B6%257D%257B7%257D" alt="\frac{4}{5}\:?\:\frac{6}{7}"&gt;&lt;/p&gt;&lt;/div&gt;</mattext> </material> <response_lid ident="response1" rcardinality="Single"> <render_choice> <response_label ident="1602"> <material> <mattext texttype="text/plain">Greater than (&gt;)</mattext> </material> </response_label> <response_label ident="8292"> <material> <mattext texttype="text/plain">Less than (&lt;)</mattext> </material> </response_label> <response_label ident="2753"> <material> <mattext texttype="text/plain">Equivalent (=)</mattext> </material> </response_label> </render_choice> </response_lid> </presentation> <resprocessing> <outcomes> <decvar maxvalue="100" minvalue="0" varname="SCORE" vartype="Decimal"/> </outcomes> <respcondition continue="No"> <conditionvar> <varequal respident="response1">1602</varequal> </conditionvar> <setvar action="Set" varname="SCORE">100</setvar> </respcondition> </resprocessing> </item>'
      @item = Item.from_xml(@xml, @section)
    end

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

    it 'should add keywords to assessment' do
      keyword = FactoryGirl.generate(:name)
      @item.keyword_list.add(keyword, parse: true)
      @item.save
      Item.tagged_with(keyword).first.should eq(@item)
    end
  end

  describe 'results' do
    before do
      @section = FactoryGirl.create(:section)
      identifier = FactoryGirl.generate(:name)
      @eid = FactoryGirl.generate(:name)
      @xml = '<item ident="' + identifier + '" title="Question 2"> <itemmetadata> <qtimetadata> <qtimetadatafield> <fieldlabel>question_type</fieldlabel> <fieldentry>multiple_choice_question</fieldentry> </qtimetadatafield> <qtimetadatafield> <fieldlabel>points_possible</fieldlabel> <fieldentry>1</fieldentry> </qtimetadatafield> <qtimetadatafield> <fieldlabel>assessment_question_identifierref</fieldlabel> <fieldentry>ib550dd245ac5e15799afb9245f6548ff</fieldentry> </qtimetadatafield> </qtimetadata> </itemmetadata> <presentation> <material> <mattext texttype="text/html">&lt;div&gt;&lt;p&gt;&lt;img class="equation_image" title="\frac{4}{5}\:?\:\frac{6}{7}" src="https://canvas.instructure.com/equation_images/%255Cfrac%257B4%257D%257B5%257D%255C%253A%253F%255C%253A%255Cfrac%257B6%257D%257B7%257D" alt="\frac{4}{5}\:?\:\frac{6}{7}"&gt;&lt;/p&gt;&lt;/div&gt;</mattext> </material> <response_lid ident="response1" rcardinality="Single"> <render_choice> <response_label ident="1602"> <material> <mattext texttype="text/plain">Greater than (&gt;)</mattext> </material> </response_label> <response_label ident="8292"> <material> <mattext texttype="text/plain">Less than (&lt;)</mattext> </material> </response_label> <response_label ident="2753"> <material> <mattext texttype="text/plain">Equivalent (=)</mattext> </material> </response_label> </render_choice> </response_lid> </presentation> <resprocessing> <outcomes> <decvar maxvalue="100" minvalue="0" varname="SCORE" vartype="Decimal"/> </outcomes> <respcondition continue="No"> <conditionvar> <varequal respident="response1">1602</varequal> </conditionvar> <setvar action="Set" varname="SCORE">100</setvar> </respcondition> </resprocessing> </item>'
      @item = Item.from_xml(@xml, @section)
      @item_result = ItemResult.new(
        identifier: @item.identifier,
        eid: @eid,
        item_id: @item.id,
        rendered_datestamp: Time.now-1,
        datestamp: Time.now,
        referer: 'http://localhost:3000/items',
        ip_address: "127.0.0.1",
        session_status: "final"
      )
      @item.item_results << @item_result
    end

    describe 'raw results' do

      it 'should return results with identifier' do
        results = Item.raw_results(scope_url: nil, identifier: @item.identifier, keyword: nil)
        results.should include(@item_result)
      end

      it 'should return results with eid' do
        results = Item.raw_results(scope_url: nil, eid: @eid, keyword: nil)
        expect(results).to include(@item_result)
      end

      it 'should return no results when no matching eid' do
        results = Item.raw_results(scope_url: nil, eid: FactoryGirl.generate(:name), keyword: nil)
        expect(results.empty?).to eq(true)
      end

      it 'should return results with multiple matching eid' do
        @item_result2 = ItemResult.new(
          identifier: @item.identifier,
          eid: @eid,
          item_id: @item.id,
          rendered_datestamp: Time.now-1,
          datestamp: Time.now,
          referer: 'http://localhost:3000/items',
          ip_address: "127.0.0.1",
          session_status: "final"
        )
        @item.item_results << @item_result2
        results = Item.raw_results(scope_url: nil, eid: @eid, keyword: nil)
        expect(results).to eq([@item_result, @item_result2])
      end

      it 'should not return results with identifier' do
        identifier = FactoryGirl.generate(:name)
        @xml2 = '<item ident="' + identifier + '" title="Question 2"> <itemmetadata> <qtimetadata> <qtimetadatafield> <fieldlabel>question_type</fieldlabel> <fieldentry>multiple_choice_question</fieldentry> </qtimetadatafield> <qtimetadatafield> <fieldlabel>points_possible</fieldlabel> <fieldentry>1</fieldentry> </qtimetadatafield> <qtimetadatafield> <fieldlabel>assessment_question_identifierref</fieldlabel> <fieldentry>ib550dd245ac5e15799afb9245f6548ff</fieldentry> </qtimetadatafield> </qtimetadata> </itemmetadata> <presentation> <material> <mattext texttype="text/html">&lt;div&gt;&lt;p&gt;&lt;img class="equation_image" title="\frac{4}{5}\:?\:\frac{6}{7}" src="https://canvas.instructure.com/equation_images/%255Cfrac%257B4%257D%257B5%257D%255C%253A%253F%255C%253A%255Cfrac%257B6%257D%257B7%257D" alt="\frac{4}{5}\:?\:\frac{6}{7}"&gt;&lt;/p&gt;&lt;/div&gt;</mattext> </material> <response_lid ident="response1" rcardinality="Single"> <render_choice> <response_label ident="1602"> <material> <mattext texttype="text/plain">Greater than (&gt;)</mattext> </material> </response_label> <response_label ident="8292"> <material> <mattext texttype="text/plain">Less than (&lt;)</mattext> </material> </response_label> <response_label ident="2753"> <material> <mattext texttype="text/plain">Equivalent (=)</mattext> </material> </response_label> </render_choice> </response_lid> </presentation> <resprocessing> <outcomes> <decvar maxvalue="100" minvalue="0" varname="SCORE" vartype="Decimal"/> </outcomes> <respcondition continue="No"> <conditionvar> <varequal respident="response1">1602</varequal> </conditionvar> <setvar action="Set" varname="SCORE">100</setvar> </respcondition> </resprocessing> </item>'
        @item2 = Item.from_xml(@xml2, @section)
        results = Item.raw_results(scope_url: nil, identifier: @item.identifier, keyword: nil)
        results.should_not include(@item2.item_results)
      end

      it 'should return results with keyword' do
        keyword = 'classroom1'
        assessment = make_assessment
        assessment.keyword_list.add(keyword, parse: true)
        assessment.sections << @section
        assessment.save
        results = Item.raw_results(scope_url: nil, identifier: nil, keyword: keyword)
        results.should include(assessment.items.first.item_results.first)
      end

      it 'should not return results with keyword' do
        keyword = 'classroom1'
        assessment = make_assessment
        assessment.sections << @section
        results = Item.raw_results(scope_url: nil, identifier: nil, keyword: keyword)
        results.should_not include(@item_result)
      end

      it 'should return results with external_user_id' do
        external_user_id = FactoryGirl.generate(:name)
        assessment = make_assessment
        assessment_result = FactoryGirl.create(:assessment_result, assessment: assessment)
        assessment_result.update_attribute(:external_user_id, external_user_id)
        assessment.sections << @section
        assessment_result.item_results << @item_result
        assessment.save
        assessment_result.save
        results = Item.raw_results(scope_url: nil, identifier: nil, keyword: nil, external_user_id: external_user_id)
        results.should include(assessment.items.first.item_results.first)
      end

      it 'should not return results with external_user_id' do
        external_user_id = FactoryGirl.generate(:name)
        assessment = make_assessment
        assessment_result = FactoryGirl.create(:assessment_result, assessment: assessment)
        assessment_result.update_attribute(:external_user_id, external_user_id)
        assessment.sections << @section
        assessment.save
        assessment_result.save
        results = Item.raw_results(scope_url: nil, identifier: nil, keyword: nil, external_user_id: external_user_id)
        results.should_not include(@item_result)
      end

      it 'should return results with src_url' do
        src_url = FactoryGirl.generate(:name)
        assessment = make_assessment
        assessment_result = FactoryGirl.create(:assessment_result, assessment: assessment)
        assessment_result.update_attribute(:src_url, src_url)
        assessment.sections << @section
        assessment_result.item_results << @item_result
        assessment.save
        assessment_result.save
        results = Item.raw_results(scope_url: nil, identifier: nil, keyword: nil, src_url: src_url)
        results.should include(assessment.items.first.item_results.first)
      end

      it 'should not return results with src_url' do
        src_url = FactoryGirl.generate(:name)
        assessment = make_assessment
        assessment_result = FactoryGirl.create(:assessment_result, assessment: assessment)
        assessment_result.update_attribute(:src_url, src_url)
        assessment.sections << @section
        assessment.save
        assessment_result.save
        results = Item.raw_results(scope_url: nil, identifier: nil, keyword: nil, src_url: src_url)
        results.should_not include(@item_result)
      end

      it 'should return results with scope' do
        results = Item.raw_results(scope_url: @item_result.referer, identifier: nil, keyword: nil)
        results.should include(@item_result)
      end
    end

    describe 'results summary' do

      it 'should return results with eid' do
        results = Item.results_summary(scope_url: nil, eid: @eid, keyword: nil)
        expect(results[:submitted]).to include(@item_result)
      end

      it 'should return no results when no matching eid' do
        results = Item.results_summary(scope_url: nil, eid: FactoryGirl.generate(:name), keyword: nil)
        expect(results[:submitted].empty?).to eq(true)
      end

      it 'should return results with multiple matching eid' do
        @item_result2 = ItemResult.new(
          identifier: @item.identifier,
          eid: @eid,
          item_id: @item.id,
          rendered_datestamp: Time.now-1,
          datestamp: Time.now,
          referer: 'http://localhost:3000/items',
          ip_address: "127.0.0.1",
          session_status: "final"
        )
        @item.item_results << @item_result2
        results = Item.results_summary(scope_url: nil, eid: @eid, keyword: nil)
        expect(results[:submitted]).to eq([@item_result, @item_result2])
      end

      it 'should return results with identifier' do
        results = Item.results_summary(scope_url: nil, identifier: @item.identifier, keyword: nil)
        results[:submitted].should include(@item_result)
      end

      it 'should not return results with identifier' do
        identifier = FactoryGirl.generate(:name)
        @section2 = FactoryGirl.create(:section)
        @xml2 = '<item ident="' + identifier + '" title="Question 2"> <itemmetadata> <qtimetadata> <qtimetadatafield> <fieldlabel>question_type</fieldlabel> <fieldentry>multiple_choice_question</fieldentry> </qtimetadatafield> <qtimetadatafield> <fieldlabel>points_possible</fieldlabel> <fieldentry>1</fieldentry> </qtimetadatafield> <qtimetadatafield> <fieldlabel>assessment_question_identifierref</fieldlabel> <fieldentry>ib550dd245ac5e15799afb9245f6548ff</fieldentry> </qtimetadatafield> </qtimetadata> </itemmetadata> <presentation> <material> <mattext texttype="text/html">&lt;div&gt;&lt;p&gt;&lt;img class="equation_image" title="\frac{4}{5}\:?\:\frac{6}{7}" src="https://canvas.instructure.com/equation_images/%255Cfrac%257B4%257D%257B5%257D%255C%253A%253F%255C%253A%255Cfrac%257B6%257D%257B7%257D" alt="\frac{4}{5}\:?\:\frac{6}{7}"&gt;&lt;/p&gt;&lt;/div&gt;</mattext> </material> <response_lid ident="response1" rcardinality="Single"> <render_choice> <response_label ident="1602"> <material> <mattext texttype="text/plain">Greater than (&gt;)</mattext> </material> </response_label> <response_label ident="8292"> <material> <mattext texttype="text/plain">Less than (&lt;)</mattext> </material> </response_label> <response_label ident="2753"> <material> <mattext texttype="text/plain">Equivalent (=)</mattext> </material> </response_label> </render_choice> </response_lid> </presentation> <resprocessing> <outcomes> <decvar maxvalue="100" minvalue="0" varname="SCORE" vartype="Decimal"/> </outcomes> <respcondition continue="No"> <conditionvar> <varequal respident="response1">1602</varequal> </conditionvar> <setvar action="Set" varname="SCORE">100</setvar> </respcondition> </resprocessing> </item>'
        @item2 = Item.from_xml(@xml2, @section2)
        results = Item.results_summary(scope_url: nil, identifier: @item2.identifier, keyword: nil)
        results[:submitted].should_not include(@item_result)
      end

      it 'should return results with keyword' do
        keyword = 'classroom2'
        assessment = make_assessment
        assessment.keyword_list.add(keyword, parse: true)
        assessment.sections << @section
        assessment.save
        results = Item.results_summary(scope_url: nil, identifier: nil, keyword: keyword)
        results[:submitted].should include(assessment.items.first.item_results.first)
      end

      it 'should not return results with keyword' do
        keyword = 'classroom2'
        assessment = make_assessment
        assessment.sections << @section
        results = Item.results_summary(scope_url: nil, identifier: nil, keyword: keyword)
        results[:submitted].should_not include(@item_result)
      end

      it 'should return results with external_user_id' do
        external_user_id = FactoryGirl.generate(:name)
        assessment = make_assessment
        assessment_result = FactoryGirl.create(:assessment_result, assessment: assessment)
        assessment_result.update_attribute(:external_user_id, external_user_id)
        assessment.sections << @section
        assessment_result.item_results << @item_result
        assessment.save
        assessment_result.save
        results = Item.results_summary(scope_url: nil, identifier: nil, keyword: nil, external_user_id: external_user_id)
        results[:submitted].should include(assessment.items.first.item_results.first)
      end

      it 'should not return results with external_user_id' do
        external_user_id = FactoryGirl.generate(:name)
        assessment = make_assessment
        assessment_result = FactoryGirl.create(:assessment_result, assessment: assessment)
        assessment_result.update_attribute(:external_user_id, external_user_id)
        assessment.sections << @section
        assessment.save
        assessment_result.save
        results = Item.results_summary(scope_url: nil, identifier: nil, keyword: nil, external_user_id: external_user_id)
        results[:submitted].should_not include(@item_result)
      end

      it 'should return results with src_url' do
        src_url = FactoryGirl.generate(:name)
        assessment = make_assessment
        assessment_result = FactoryGirl.create(:assessment_result, assessment: assessment)
        assessment_result.update_attribute(:src_url, src_url)
        assessment.sections << @section
        assessment_result.item_results << @item_result
        assessment.save
        assessment_result.save
        results = Item.results_summary(src_url: src_url)
        results[:submitted].should include(assessment.items.first.item_results.first)
      end

      it 'should not return results with src_url' do
        src_url = FactoryGirl.generate(:name)
        assessment = make_assessment
        assessment_result = FactoryGirl.create(:assessment_result, assessment: assessment)
        assessment_result.update_attribute(:src_url, src_url)
        assessment.sections << @section
        assessment.save
        assessment_result.save
        results = Item.results_summary(src_url: src_url)
        results[:submitted].should_not include(@item_result)
      end

      it 'should return results with scope' do
        results = Item.results_summary(scope_url: @item_result.referer, identifier: nil, keyword: nil)
        results[:submitted].should include(@item_result)
      end
    end
  end

end

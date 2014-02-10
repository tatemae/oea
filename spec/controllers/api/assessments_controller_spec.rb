require 'spec_helper'

describe Api::AssessmentsController do
  before do
    @xml = open('./spec/fixtures/assessment.xml').read
  end

  describe "GET 'index'" do
    it "returns http success" do
      FactoryGirl.create(:assessment)
      get 'index', format: :json, q: 'Question'
      response.should be_success
    end
    describe "search" do
      before do
        @assessment = FactoryGirl.create(:assessment)
        @outcome = FactoryGirl.create(:outcome)
        @assessment_outcome = FactoryGirl.create(:assessment_outcome, assessment: @assessment, outcome: @outcome)
      end
      it "should return the assessment" do
        get 'index', format: :json, q: @assessment.title
        assigns(:assessments).should include(@assessment)
      end
    end
  end

  describe "GET 'show'" do
    before do
      @assessment = FactoryGirl.create(:assessment)
      @assessment_xml = AssessmentXml.create!(xml: "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<questestinterop xmlns=\"http://www.imsglobal.org/xsd/ims_qtiasiv1p2\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"http://www.imsglobal.org/xsd/ims_qtiasiv1p2 http://www.imsglobal.org/xsd/ims_qtiasiv1p2p1.xsd\">\n  <assessment ident=\"i84370e65ac8a6fa96a597c44612c1de2\" title=\"mc &amp; sa\">\n    <qtimetadata>\n      <qtimetadatafield>\n        <fieldlabel>cc_maxattempts</fieldlabel>\n        <fieldentry>1</fieldentry>\n      </qtimetadatafield>\n    </qtimetadata>\n    <section ident=\"root_section\">\n      <item ident=\"i7f0b73c230bd437902b54afe936999cd\" title=\"the mult chic\">\n        <itemmetadata>\n          <qtimetadata>\n            <qtimetadatafield>\n              <fieldlabel>question_type</fieldlabel>\n              <fieldentry>multiple_choice_question</fieldentry>\n            </qtimetadatafield>\n            <qtimetadatafield>\n              <fieldlabel>points_possible</fieldlabel>\n              <fieldentry>1</fieldentry>\n            </qtimetadatafield>\n            <qtimetadatafield>\n              <fieldlabel>assessment_question_identifierref</fieldlabel>\n              <fieldentry>i6313af431984f0cdb2f4fec664ff424c</fieldentry>\n            </qtimetadatafield>\n          </qtimetadata>\n        </itemmetadata>\n        <presentation>\n          <material>\n            <mattext texttype=\"text/html\">&lt;div&gt;&lt;p&gt;how much can you chuck?&lt;/p&gt;&lt;/div&gt;</mattext>\n          </material>\n          <response_lid ident=\"response1\" rcardinality=\"Single\">\n            <render_choice>\n              <response_label ident=\"1524\">\n                <material>\n                  <mattext texttype=\"text/plain\">not much at all</mattext>\n                </material>\n              </response_label>\n              <response_label ident=\"1744\">\n                <material>\n                  <mattext texttype=\"text/plain\">a whole TON</mattext>\n                </material>\n              </response_label>\n              <response_label ident=\"5690\">\n                <material>\n                  <mattext texttype=\"text/plain\">a hotdog</mattext>\n                </material>\n              </response_label>\n            </render_choice>\n          </response_lid>\n        </presentation>\n        <resprocessing>\n          <outcomes>\n            <decvar maxvalue=\"100\" minvalue=\"0\" varname=\"SCORE\" vartype=\"Decimal\"/>\n          </outcomes>\n          <respcondition continue=\"Yes\">\n            <conditionvar>\n              <other/>\n            </conditionvar>\n            <displayfeedback feedbacktype=\"Response\" linkrefid=\"general_fb\"/>\n          </respcondition>\n          <respcondition continue=\"Yes\">\n            <conditionvar>\n              <varequal respident=\"response1\">1524</varequal>\n            </conditionvar>\n            <displayfeedback feedbacktype=\"Response\" linkrefid=\"1524_fb\"/>\n          </respcondition>\n          <respcondition continue=\"Yes\">\n            <conditionvar>\n              <varequal respident=\"response1\">1744</varequal>\n            </conditionvar>\n            <displayfeedback feedbacktype=\"Response\" linkrefid=\"1744_fb\"/>\n          </respcondition>\n          <respcondition continue=\"No\">\n            <conditionvar>\n              <varequal respident=\"response1\">1744</varequal>\n            </conditionvar>\n            <setvar action=\"Set\" varname=\"SCORE\">100</setvar>\n            <displayfeedback feedbacktype=\"Response\" linkrefid=\"correct_fb\"/>\n          </respcondition>\n          <respcondition continue=\"Yes\">\n            <conditionvar>\n              <other/>\n            </conditionvar>\n            <displayfeedback feedbacktype=\"Response\" linkrefid=\"general_incorrect_fb\"/>\n          </respcondition>\n        </resprocessing>\n        <itemfeedback ident=\"general_fb\">\n          <flow_mat>\n            <material>\n              <mattext texttype=\"text/plain\">you can chuck a lot</mattext>\n            </material>\n          </flow_mat>\n        </itemfeedback>\n        <itemfeedback ident=\"correct_fb\">\n          <flow_mat>\n            <material>\n              <mattext texttype=\"text/plain\">that's a car!!!!!!</mattext>\n            </material>\n          </flow_mat>\n        </itemfeedback>\n        <itemfeedback ident=\"general_incorrect_fb\">\n          <flow_mat>\n            <material>\n              <mattext texttype=\"text/plain\">dude, seriously?</mattext>\n            </material>\n          </flow_mat>\n        </itemfeedback>\n        <itemfeedback ident=\"1524_fb\">\n          <flow_mat>\n            <material>\n              <mattext texttype=\"text/plain\">weakling</mattext>\n            </material>\n          </flow_mat>\n        </itemfeedback>\n        <itemfeedback ident=\"1744_fb\">\n          <flow_mat>\n            <material>\n              <mattext texttype=\"text/plain\">that's right!</mattext>\n            </material>\n          </flow_mat>\n        </itemfeedback>\n      </item>\n      <item ident=\"i26b905fa2ac9ed3ce3218bba203e958b\" title=\"the short answer\">\n        <itemmetadata>\n          <qtimetadata>\n            <qtimetadatafield>\n              <fieldlabel>question_type</fieldlabel>\n              <fieldentry>short_answer_question</fieldentry>\n            </qtimetadatafield>\n            <qtimetadatafield>\n              <fieldlabel>points_possible</fieldlabel>\n              <fieldentry>1</fieldentry>\n            </qtimetadatafield>\n            <qtimetadatafield>\n              <fieldlabel>assessment_question_identifierref</fieldlabel>\n              <fieldentry>i812edcb28e590638a4aa64d6bf497cc0</fieldentry>\n            </qtimetadatafield>\n          </qtimetadata>\n        </itemmetadata>\n        <presentation>\n          <material>\n            <mattext texttype=\"text/html\">&lt;div&gt;&lt;p&gt;What is your favorite color?&lt;/p&gt;&lt;/div&gt;</mattext>\n          </material>\n          <response_str ident=\"response1\" rcardinality=\"Single\">\n            <render_fib>\n              <response_label ident=\"answer1\" rshuffle=\"No\"/>\n            </render_fib>\n          </response_str>\n        </presentation>\n        <resprocessing>\n          <outcomes>\n            <decvar maxvalue=\"100\" minvalue=\"0\" varname=\"SCORE\" vartype=\"Decimal\"/>\n          </outcomes>\n          <respcondition continue=\"Yes\">\n            <conditionvar>\n              <other/>\n            </conditionvar>\n            <displayfeedback feedbacktype=\"Response\" linkrefid=\"general_fb\"/>\n          </respcondition>\n          <respcondition continue=\"Yes\">\n            <conditionvar>\n              <varequal respident=\"response1\">Yellow</varequal>\n            </conditionvar>\n            <displayfeedback feedbacktype=\"Response\" linkrefid=\"3389_fb\"/>\n          </respcondition>\n          <respcondition continue=\"Yes\">\n            <conditionvar>\n              <varequal respident=\"response1\">yellow</varequal>\n            </conditionvar>\n            <displayfeedback feedbacktype=\"Response\" linkrefid=\"9569_fb\"/>\n          </respcondition>\n          <respcondition continue=\"Yes\">\n            <conditionvar>\n              <varequal respident=\"response1\">amarillo</varequal>\n            </conditionvar>\n            <displayfeedback feedbacktype=\"Response\" linkrefid=\"4469_fb\"/>\n          </respcondition>\n          <respcondition continue=\"No\">\n            <conditionvar>\n              <varequal respident=\"response1\">Yellow</varequal>\n              <varequal respident=\"response1\">yellow</varequal>\n              <varequal respident=\"response1\">amarillo</varequal>\n              <varequal respident=\"response1\">blue</varequal>\n            </conditionvar>\n            <setvar action=\"Set\" varname=\"SCORE\">100</setvar>\n            <displayfeedback feedbacktype=\"Response\" linkrefid=\"correct_fb\"/>\n          </respcondition>\n          <respcondition continue=\"Yes\">\n            <conditionvar>\n              <other/>\n            </conditionvar>\n            <displayfeedback feedbacktype=\"Response\" linkrefid=\"general_incorrect_fb\"/>\n          </respcondition>\n        </resprocessing>\n        <itemfeedback ident=\"general_fb\">\n          <flow_mat>\n            <material>\n              <mattext texttype=\"text/plain\">That dude is old.</mattext>\n            </material>\n          </flow_mat>\n        </itemfeedback>\n        <itemfeedback ident=\"correct_fb\">\n          <flow_mat>\n            <material>\n              <mattext texttype=\"text/plain\">You stay on the bridge. Good job.</mattext>\n            </material>\n          </flow_mat>\n        </itemfeedback>\n        <itemfeedback ident=\"general_incorrect_fb\">\n          <flow_mat>\n            <material>\n              <mattext texttype=\"text/plain\">You were thrown off the bridge.</mattext>\n            </material>\n          </flow_mat>\n        </itemfeedback>\n        <itemfeedback ident=\"3389_fb\">\n          <flow_mat>\n            <material>\n              <mattext texttype=\"text/plain\">good</mattext>\n            </material>\n          </flow_mat>\n        </itemfeedback>\n        <itemfeedback ident=\"9569_fb\">\n          <flow_mat>\n            <material>\n              <mattext texttype=\"text/plain\">good again</mattext>\n            </material>\n          </flow_mat>\n        </itemfeedback>\n        <itemfeedback ident=\"4469_fb\">\n          <flow_mat>\n            <material>\n              <mattext texttype=\"text/plain\">spanish</mattext>\n            </material>\n          </flow_mat>\n        </itemfeedback>\n      </item>\n    </section>\n  </assessment>\n</questestinterop>\n", assessment_id: @assessment.id)
    end
    context "json" do
      it "returns http success" do
        get 'show', format: :json, id: @assessment.id
        response.should be_success
      end
    end
    context "xml" do
      it "renders the assessment QTI xml" do
        get 'show', format: :xml, id: @assessment.id
        response.should be_success
      end
    end
  end

  describe "POST 'create'" do
    before do
      @user = FactoryGirl.create(:user)
    end

    it "denies unauthenticated requests" do
      request.env['RAW_POST_DATA'] = @xml
      post 'create', format: :xml
      expect(response.status).to eq(401)
    end
    it "creates an assessment xml" do
      request.env['RAW_POST_DATA'] = @xml
      post 'create', auth_token: @user.authentication_token, format: :xml
      response.should be_success
    end
    it "creates an assessment json" do
      request.env['RAW_POST_DATA'] = @xml
      post 'create', auth_token: @user.authentication_token, format: :json
      response.should be_success
    end
  end

end

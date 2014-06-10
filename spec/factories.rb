require 'factory_girl'

FactoryGirl.define do

  sequence :identifier do |n|
    "id_#{n}"
  end

  sequence :description do |n|
    "description_#{n}"
  end

  sequence :name do |n|
    "user_#{n}"
  end

  sequence :email do |n|
    "user_#{n}@opentapestry.com"
  end

  sequence :password do |n|
    "password_#{n}"
  end

  sequence :bank_id do |n|
    "asdf#{n}"
  end

  sequence :objective_id do |n|
    "oiu#{n}"
  end

  factory :user do
    name { FactoryGirl.generate(:name) }
    email { FactoryGirl.generate(:email) }
    password { FactoryGirl.generate(:password) }
    # account
    # after_build { |user| user.confirm! }

    factory :user_facebook do
      active_avatar 'facebook'
      provider_avatar 'http://graph.facebook.com/12345/picture?type=large'
      after_build { |user| FakeWeb.register_uri(:get, user.provider_avatar, body: File.join(Rails.root, 'spec', 'fixtures', 'avatar.jpg')) }
    end

    factory :user_with_avatar do
      avatar { File.open File.join(Rails.root, 'spec', 'fixtures', 'avatar.jpg') }
    end
  end

  factory :assessment do
    identifier { FactoryGirl.generate(:identifier) }
    title { FactoryGirl.generate(:name) }
    description { FactoryGirl.generate(:description) }
  end

  factory :assessment_xml do
    xml "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<questestinterop xmlns=\"http://www.imsglobal.org/xsd/ims_qtiasiv1p2\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"http://www.imsglobal.org/xsd/ims_qtiasiv1p2 http://www.imsglobal.org/xsd/ims_qtiasiv1p2p1.xsd\">\n  <assessment ident=\"i84370e65ac8a6fa96a597c44612c1de2\" title=\"mc &amp; sa\">\n    <qtimetadata>\n      <qtimetadatafield>\n        <fieldlabel>cc_maxattempts</fieldlabel>\n        <fieldentry>1</fieldentry>\n      </qtimetadatafield>\n    </qtimetadata>\n    <section ident=\"root_section\">\n      <item ident=\"i7f0b73c230bd437902b54afe936999cd\" title=\"the mult chic\">\n        <itemmetadata>\n          <qtimetadata>\n            <qtimetadatafield>\n              <fieldlabel>question_type</fieldlabel>\n              <fieldentry>multiple_choice_question</fieldentry>\n            </qtimetadatafield>\n            <qtimetadatafield>\n              <fieldlabel>points_possible</fieldlabel>\n              <fieldentry>1</fieldentry>\n            </qtimetadatafield>\n            <qtimetadatafield>\n              <fieldlabel>assessment_question_identifierref</fieldlabel>\n              <fieldentry>i6313af431984f0cdb2f4fec664ff424c</fieldentry>\n            </qtimetadatafield>\n          </qtimetadata>\n        </itemmetadata>\n        <presentation>\n          <material>\n            <mattext texttype=\"text/html\">&lt;div&gt;&lt;p&gt;how much can you chuck?&lt;/p&gt;&lt;/div&gt;</mattext>\n          </material>\n          <response_lid ident=\"response1\" rcardinality=\"Single\">\n            <render_choice>\n              <response_label ident=\"1524\">\n                <material>\n                  <mattext texttype=\"text/plain\">not much at all</mattext>\n                </material>\n              </response_label>\n              <response_label ident=\"1744\">\n                <material>\n                  <mattext texttype=\"text/plain\">a whole TON</mattext>\n                </material>\n              </response_label>\n              <response_label ident=\"5690\">\n                <material>\n                  <mattext texttype=\"text/plain\">a hotdog</mattext>\n                </material>\n              </response_label>\n            </render_choice>\n          </response_lid>\n        </presentation>\n        <resprocessing>\n          <outcomes>\n            <decvar maxvalue=\"100\" minvalue=\"0\" varname=\"SCORE\" vartype=\"Decimal\"/>\n          </outcomes>\n          <respcondition continue=\"Yes\">\n            <conditionvar>\n              <other/>\n            </conditionvar>\n            <displayfeedback feedbacktype=\"Response\" linkrefid=\"general_fb\"/>\n          </respcondition>\n          <respcondition continue=\"Yes\">\n            <conditionvar>\n              <varequal respident=\"response1\">1524</varequal>\n            </conditionvar>\n            <displayfeedback feedbacktype=\"Response\" linkrefid=\"1524_fb\"/>\n          </respcondition>\n          <respcondition continue=\"Yes\">\n            <conditionvar>\n              <varequal respident=\"response1\">1744</varequal>\n            </conditionvar>\n            <displayfeedback feedbacktype=\"Response\" linkrefid=\"1744_fb\"/>\n          </respcondition>\n          <respcondition continue=\"No\">\n            <conditionvar>\n              <varequal respident=\"response1\">1744</varequal>\n            </conditionvar>\n            <setvar action=\"Set\" varname=\"SCORE\">100</setvar>\n            <displayfeedback feedbacktype=\"Response\" linkrefid=\"correct_fb\"/>\n          </respcondition>\n          <respcondition continue=\"Yes\">\n            <conditionvar>\n              <other/>\n            </conditionvar>\n            <displayfeedback feedbacktype=\"Response\" linkrefid=\"general_incorrect_fb\"/>\n          </respcondition>\n        </resprocessing>\n        <itemfeedback ident=\"general_fb\">\n          <flow_mat>\n            <material>\n              <mattext texttype=\"text/plain\">you can chuck a lot</mattext>\n            </material>\n          </flow_mat>\n        </itemfeedback>\n        <itemfeedback ident=\"correct_fb\">\n          <flow_mat>\n            <material>\n              <mattext texttype=\"text/plain\">that's a car!!!!!!</mattext>\n            </material>\n          </flow_mat>\n        </itemfeedback>\n        <itemfeedback ident=\"general_incorrect_fb\">\n          <flow_mat>\n            <material>\n              <mattext texttype=\"text/plain\">dude, seriously?</mattext>\n            </material>\n          </flow_mat>\n        </itemfeedback>\n        <itemfeedback ident=\"1524_fb\">\n          <flow_mat>\n            <material>\n              <mattext texttype=\"text/plain\">weakling</mattext>\n            </material>\n          </flow_mat>\n        </itemfeedback>\n        <itemfeedback ident=\"1744_fb\">\n          <flow_mat>\n            <material>\n              <mattext texttype=\"text/plain\">that's right!</mattext>\n            </material>\n          </flow_mat>\n        </itemfeedback>\n      </item>\n      <item ident=\"i26b905fa2ac9ed3ce3218bba203e958b\" title=\"the short answer\">\n        <itemmetadata>\n          <qtimetadata>\n            <qtimetadatafield>\n              <fieldlabel>question_type</fieldlabel>\n              <fieldentry>short_answer_question</fieldentry>\n            </qtimetadatafield>\n            <qtimetadatafield>\n              <fieldlabel>points_possible</fieldlabel>\n              <fieldentry>1</fieldentry>\n            </qtimetadatafield>\n            <qtimetadatafield>\n              <fieldlabel>assessment_question_identifierref</fieldlabel>\n              <fieldentry>i812edcb28e590638a4aa64d6bf497cc0</fieldentry>\n            </qtimetadatafield>\n          </qtimetadata>\n        </itemmetadata>\n        <presentation>\n          <material>\n            <mattext texttype=\"text/html\">&lt;div&gt;&lt;p&gt;What is your favorite color?&lt;/p&gt;&lt;/div&gt;</mattext>\n          </material>\n          <response_str ident=\"response1\" rcardinality=\"Single\">\n            <render_fib>\n              <response_label ident=\"answer1\" rshuffle=\"No\"/>\n            </render_fib>\n          </response_str>\n        </presentation>\n        <resprocessing>\n          <outcomes>\n            <decvar maxvalue=\"100\" minvalue=\"0\" varname=\"SCORE\" vartype=\"Decimal\"/>\n          </outcomes>\n          <respcondition continue=\"Yes\">\n            <conditionvar>\n              <other/>\n            </conditionvar>\n            <displayfeedback feedbacktype=\"Response\" linkrefid=\"general_fb\"/>\n          </respcondition>\n          <respcondition continue=\"Yes\">\n            <conditionvar>\n              <varequal respident=\"response1\">Yellow</varequal>\n            </conditionvar>\n            <displayfeedback feedbacktype=\"Response\" linkrefid=\"3389_fb\"/>\n          </respcondition>\n          <respcondition continue=\"Yes\">\n            <conditionvar>\n              <varequal respident=\"response1\">yellow</varequal>\n            </conditionvar>\n            <displayfeedback feedbacktype=\"Response\" linkrefid=\"9569_fb\"/>\n          </respcondition>\n          <respcondition continue=\"Yes\">\n            <conditionvar>\n              <varequal respident=\"response1\">amarillo</varequal>\n            </conditionvar>\n            <displayfeedback feedbacktype=\"Response\" linkrefid=\"4469_fb\"/>\n          </respcondition>\n          <respcondition continue=\"No\">\n            <conditionvar>\n              <varequal respident=\"response1\">Yellow</varequal>\n              <varequal respident=\"response1\">yellow</varequal>\n              <varequal respident=\"response1\">amarillo</varequal>\n              <varequal respident=\"response1\">blue</varequal>\n            </conditionvar>\n            <setvar action=\"Set\" varname=\"SCORE\">100</setvar>\n            <displayfeedback feedbacktype=\"Response\" linkrefid=\"correct_fb\"/>\n          </respcondition>\n          <respcondition continue=\"Yes\">\n            <conditionvar>\n              <other/>\n            </conditionvar>\n            <displayfeedback feedbacktype=\"Response\" linkrefid=\"general_incorrect_fb\"/>\n          </respcondition>\n        </resprocessing>\n        <itemfeedback ident=\"general_fb\">\n          <flow_mat>\n            <material>\n              <mattext texttype=\"text/plain\">That dude is old.</mattext>\n            </material>\n          </flow_mat>\n        </itemfeedback>\n        <itemfeedback ident=\"correct_fb\">\n          <flow_mat>\n            <material>\n              <mattext texttype=\"text/plain\">You stay on the bridge. Good job.</mattext>\n            </material>\n          </flow_mat>\n        </itemfeedback>\n        <itemfeedback ident=\"general_incorrect_fb\">\n          <flow_mat>\n            <material>\n              <mattext texttype=\"text/plain\">You were thrown off the bridge.</mattext>\n            </material>\n          </flow_mat>\n        </itemfeedback>\n        <itemfeedback ident=\"3389_fb\">\n          <flow_mat>\n            <material>\n              <mattext texttype=\"text/plain\">good</mattext>\n            </material>\n          </flow_mat>\n        </itemfeedback>\n        <itemfeedback ident=\"9569_fb\">\n          <flow_mat>\n            <material>\n              <mattext texttype=\"text/plain\">good again</mattext>\n            </material>\n          </flow_mat>\n        </itemfeedback>\n        <itemfeedback ident=\"4469_fb\">\n          <flow_mat>\n            <material>\n              <mattext texttype=\"text/plain\">spanish</mattext>\n            </material>\n          </flow_mat>\n        </itemfeedback>\n      </item>\n    </section>\n  </assessment>\n</questestinterop>\n"
  end

  factory :section do
    assessment
    identifier { FactoryGirl.generate(:identifier) }
  end

  factory :item do
    section
    identifier { FactoryGirl.generate(:identifier) }
    feedback "{\"Yellow\":[\"3389_fb\",\"correct_fb\"],\"yellow\":[\"9569_fb\",\"correct_fb\"],\"amarillo\":[\"4469_fb\",\"correct_fb\"],\"blue\":[\"correct_fb\"]}"
    item_feedback "{\"general_fb\":[\"That dude is old.\"],\"correct_fb\":[\"You stay on the bridge. Good job.\"],\"general_incorrect_fb\":[\"You were thrown off the bridge.\"],\"3389_fb\":[\"good\"],\"9569_fb\":[\"good again\"],\"4469_fb\":[\"spanish\"]}"
    correct_responses "[\"Yellow\",\"yellow\",\"amarillo\",\"blue\"]"
  end

  factory :assessment_result do
    assessment
  end

  factory :item_result do
    item
    user
    assessment_result

    session_status { 'initial' }

  end

  factory :assessment_outcome do
    assessment
    outcome
  end

  factory :outcome do
    name { FactoryGirl.generate(:name) }
    mc3_bank_id { FactoryGirl.generate(:bank_id) }
    mc3_objective_id { FactoryGirl.generate(:objective_id) }
  end

end

require 'factory_girl'

FactoryGirl.define do

  sequence :identifier do |n|
    "id_#{n}"
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

  # factory :assessment do
  #   identifier { FactoryGirl.generate(:identifier) }
  #   xml <<-CODE.gsub(/\s+/, ' ').strip
  #     open('./spec/fixtures/test.xml').read
  #     CODE
  # end

  # factory :section do
  #   identifier { FactoryGirl.generate(:identifier) }
  # end

  factory :item do
    identifier { FactoryGirl.generate(:identifier) }
    xml <<-CODE.gsub(/\s+/, ' ').strip
      <item ident="i3590da31ca486c260f96e955482aca41" title="Question 1">
          <itemmetadata>
            <qtimetadata>
              <qtimetadatafield>
                <fieldlabel>question_type</fieldlabel>
                <fieldentry>multiple_choice_question</fieldentry>
              </qtimetadatafield>
              <qtimetadatafield>
                <fieldlabel>points_possible</fieldlabel>
                <fieldentry>1</fieldentry>
              </qtimetadatafield>
              <qtimetadatafield>
                <fieldlabel>assessment_question_identifierref</fieldlabel>
                <fieldentry>icee9d09b0a2ace374f01019034d68155</fieldentry>
              </qtimetadatafield>
            </qtimetadata>
          </itemmetadata>
          <presentation>
            <material>
              <mattext texttype="text/html">&lt;div&gt;&lt;p&gt;&lt;img class="equation_image" title="\frac{5}{12}\:?\:\frac{3}{5}" src="//latex.codecogs.com/gif.latex?%255Cfrac%257B5%257D%257B12%257D%255C%253A%253F%255C%253A%255Cfrac%257B3%257D%257B5%257D" alt="\frac{5}{12}\:?\:\frac{3}{5}"&gt;&lt;/p&gt;&lt;/div&gt;</mattext>
            </material>
            <response_lid ident="response1" rcardinality="Single">
              <render_choice>
                <response_label ident="4868">
                  <material>
                    <mattext texttype="text/plain">Greater than (&gt;)</mattext>
                  </material>
                </response_label>
                <response_label ident="3053">
                  <material>
                    <mattext texttype="text/plain">Less than (&lt;)</mattext>
                  </material>
                </response_label>
                <response_label ident="7562">
                  <material>
                    <mattext texttype="text/plain">Equivalent (=)</mattext>
                  </material>
                </response_label>
              </render_choice>
            </response_lid>
          </presentation>
          <resprocessing>
            <outcomes>
              <decvar maxvalue="100" minvalue="0" varname="SCORE" vartype="Decimal"/>
            </outcomes>
            <respcondition continue="No">
              <conditionvar>
                <varequal respident="response1">3053</varequal>
              </conditionvar>
              <setvar action="Set" varname="SCORE">100</setvar>
            </respcondition>
          </resprocessing>
        </item>
      CODE
  end

end

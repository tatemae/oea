require 'spec_helper'

describe ItemResultsController do
  before do
    @item = Item.new
    @item.identifier = "39sdfksdf93ksef9sdaksea93"
    @item.xml = "<item ident=\"i3590da31ca486c260f96e955482aca41\" title=\"Question 1\">\n        <itemmetadata>\n          <qtimetadata>\n            <qtimetadatafield>\n              <fieldlabel>question_type</fieldlabel>\n              <fieldentry>multiple_choice_question</fieldentry>\n            </qtimetadatafield>\n            <qtimetadatafield>\n              <fieldlabel>points_possible</fieldlabel>\n              <fieldentry>1</fieldentry>\n            </qtimetadatafield>\n            <qtimetadatafield>\n              <fieldlabel>assessment_question_identifierref</fieldlabel>\n              <fieldentry>icee9d09b0a2ace374f01019034d68155</fieldentry>\n            </qtimetadatafield>\n          </qtimetadata>\n        </itemmetadata>\n        <presentation>\n          <material>\n            <mattext texttype=\"text/html\">&lt;div&gt;&lt;p&gt;&lt;img class=\"equation_image\" title=\"\\frac{5}{12}\\:?\\:\\frac{3}{5}\" src=\"http://latex.codecogs.com/gif.latex?%255Cfrac%257B5%257D%257B12%257D%255C%253A%253F%255C%253A%255Cfrac%257B3%257D%257B5%257D\" alt=\"\\frac{5}{12}\\:?\\:\\frac{3}{5}\"&gt;&lt;/p&gt;&lt;/div&gt;</mattext>\n          </material>\n          <response_lid ident=\"response1\" rcardinality=\"Single\">\n            <render_choice>\n              <response_label ident=\"4868\">\n                <material>\n                  <mattext texttype=\"text/plain\">Greater than (&gt;)</mattext>\n                </material>\n              </response_label>\n              <response_label ident=\"3053\">\n                <material>\n                  <mattext texttype=\"text/plain\">Less than (&lt;)</mattext>\n                </material>\n              </response_label>\n              <response_label ident=\"7562\">\n                <material>\n                  <mattext texttype=\"text/plain\">Equivalent (=)</mattext>\n                </material>\n              </response_label>\n            </render_choice>\n          </response_lid>\n        </presentation>\n        <resprocessing>\n          <outcomes>\n            <decvar maxvalue=\"100\" minvalue=\"0\" varname=\"SCORE\" vartype=\"Decimal\"/>\n          </outcomes>\n          <respcondition continue=\"No\">\n            <conditionvar>\n              <varequal respident=\"response1\">3053</varequal>\n            </conditionvar>\n            <setvar action=\"Set\" varname=\"SCORE\">100</setvar>\n          </respcondition>\n        </resprocessing>\n      </item>"
    @item.save!
  end

end

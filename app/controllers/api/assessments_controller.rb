class Api::AssessmentsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  respond_to :xml

  def create
    assessment_xml = request.body.read
    ident = AssessmentParser.parse(assessment_xml).first.ident
    unless assessment = Assessment.find_by_identifier(ident)
      assessment = Assessment.new(xml: assessment_xml)
      assessment.save!
    end
    respond_with(assessment, location: nil)
  end
end

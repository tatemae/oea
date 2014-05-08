xml.instruct!
xml.questestinterop(
  'xmlns' => 'http://www.imsglobal.org/xsd/ims_qtiasiv1p2',
  'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
  'xsi:schemaLocation' => 'http://www.imsglobal.org/xsd/ims_qtiasiv1p2 http://www.imsglobal.org/xsd/ims_qtiasiv1p2p1.xsd') do
  @assessments.each do |assessment|
    xml.assessment(id: assessment.id, ident: assessment.identifier, title: assessment.title, description: assessment.description )
  end
end

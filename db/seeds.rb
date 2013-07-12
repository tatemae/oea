xml_file = File.open("db/seeds/assessment.xml", "rb")
Assessment.from_xml(xml_file)
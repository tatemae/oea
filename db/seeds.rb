admin = User.find_by_email('admin@openassessments.com')
if(!admin)
  admin = User.new
  admin.name = 'admin'
  admin.email = 'admin@openassessments.com'
  admin.password = "asdfasdf"
  admin.password_confirmation = "asdfasdf"
  admin.save!
  puts "Created admin user. Please login with email 'admin@openassessments.com' and password 'asdfasdf' and change the password."
end

# Load QTI files
Dir.glob("db/seeds/qti/*") do |f|
  puts "****************************************************************"
  puts "Adding QTI file #{f}"
  puts "****************************************************************"
  xml_file = File.open(f, "rb").read
  Assessment.from_xml(xml_file, admin, nil, nil, f)
end

if assessment = Assessment.find_by(title: 'drupal.xml')
  assessment.recommended_height = 960
  assessment.save!
end
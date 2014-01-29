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

xml_file = File.open("db/seeds/assessment.xml", "rb").read
Assessment.from_xml(xml_file, admin)

xml_file = File.open("db/seeds/assessment1.xml", "rb").read
Assessment.from_xml(xml_file, admin)
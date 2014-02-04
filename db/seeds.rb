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
  puts "Adding QTI file #{f}"
  xml_file = File.open(f, "rb").read
  Assessment.from_xml(xml_file, admin, nil, nil, f)
end


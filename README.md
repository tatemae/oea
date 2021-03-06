oea
===
Open Embeddable Assessment

deploy
======
run `bin/deploy` to deploy

QTI
===
Most qti in active use seems to be the qti 1.2 lite variant. Full qti comes packaged in a zip file.

oEmbed
======
See the API Documentation for the documentation on oEmbed.

edX Support
======
Open Assessments supports the drag and drop and multiple choice question types from edX. 
For more information on the edX xml structure see http://edx-open-learning-xml.readthedocs.org/en/latest/index.html

Assessment by Url
======
Assessments can be loaded directly from a remote url - the assessment need not be loaded into http://www.openassessments.com. 
Just specify a src_url. CORS must be enabled on the server specified by src_url. Example:

http://www.openassessments.com/assessments/load?confidence_levels=true&eid=atest&src_url=https%253A%252F%252Fdl.dropboxusercontent.com%252Fu%252F7594429%252FedXCourse%252Fsequential%252F97cc2d1812204294b5fcbb91a1157368.xml

Stats
======
For assessments loaded into http://www.openassessments.com you simply need to browse to the assessment and click on the bar graph. 
Stats are available on the site, as json and as csv. Loading stats for an assessment that was loaded via a src_url is a bit trickier.
You'll want to specify an 'eid' (external identifier). In theory you can query later on based on src_url but that makes things hard to control and a 
bit unpredictable. Here's an example using our MIT edX course:

http://www.openassessments.com/assessments/load?confidence_levels=true&eid=atest&src_url=https%253A%252F%252Fdl.dropboxusercontent.com%252Fu%252F7594429%252FedXCourse%252Fsequential%252F97cc2d1812204294b5fcbb91a1157368.xml

For that assessment, the eid specified was 'atest'. View the stats by asking for them by eid. Note that the /0? is important in the url as it tells the system
that you want to find the stats by eid rather than by id:

html:
http://www.openassessments.com/assessment_results/0?eid=atest

csv:
http://www.openassessments.com/assessment_results/0.csv?eid=atest

json:
http://www.openassessments.com/assessment_results/0.json?eid=atest

We recommend using a GUID for the eid to prevent conflicts with other assessments.


Getting ruby-saml-mod to work on Heroku.
========================================

Here are my notes on how to add libraries, that are required by the ruby saml mod gem, to Heroku.

The ruby saml gem uses the xmlsec and xmlsec-openssl shared libraries. It appears that these libraries are not installed on the Heroku cedar platform.

Heroku cedar is based on ubuntu 10.04 64-bit. So binary dependencies that are compatible with Heroku can be found on packages.ubuntu.com. Find and download the deb package, and unpack it. ruby-saml-mod depends on libraries that can be found in two debian packages:

    libxmlsec1_1.2.9-5ubuntu5_amd64.deb
    libxmlsec1-openssl_1.2.9-5ubuntu5_amd64.deb

If you are on a Mac you can unpack a deb package using the ar utility.

ar -x libxmlsec1-openssl_1.2.9-5ubuntu5_amd64.deb

The library files are:

    libxmlsec1.so.1.2.9
    libxmlsec1-openssl.so.1.2.9

The files that you need in the directory where the libraries are stored:

    libxmlsec1-openssl.so -> libxmlsec1-openssl.so.1.2.9
    libxmlsec1-openssl.so.1 -> libxmlsec1-openssl.so.1.2.9
    libxmlsec1-openssl.so.1.2.9
    libxmlsec1.so -> libxmlsec1.so.1.2.9
    libxmlsec1.so.1 -> libxmlsec1.so.1.2.9
    libxmlsec1.so.1.2.9

The other files are symlinks to the real libraries. They are required and need to be checked into the repo. Use ls -l in the directory where the libraries and symlinks live to ensure that the symlinks are relative paths.

An alternative to committing the files to the repository is to use build packs. If you decide to go the buildpack route, you will probably have to use the multi buildpack.

When Heroku precompiles assets it uses a different environment than for running the application. So the build will fail, because the saml gem cannot find its library dependencies, even if the runtime environment is configured correctly. One way to work around this situation is to move the require statements for the saml gem into the controller class methods where the gem is used. This way the require is not called during the build step. Another possiblity is to use a Heroku labs feature to use the runtime environment variables for the build environment.

For the gem to know where to find the library, you need to set the LD_LIBRARY_PATH var to the absolute path to the folder with your libs. On Heroku an app lives in the /app directory. So, if your libraries are in the vendor/libs directory in your repository, set LD_LIBRARY_PATH to /app/vendor/libs.

The saml gem requires the following config variables(listed with an example value):

  entity_id:                      http://serviceprovider.example.com/saml
  idp_cert_fingerprint:           ae:io:uy:ae:io:uy
  idp_sso_target_url:             https://idp.example.com/idp/
  issuer:                         serviceprovider.example.com
  name_identifier_format:         urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress
  saml_certificate:               /path/to/serviceprovider.example.com.crt
  saml_private_key:               /path/to/serviceprovider.example.com.key
  support_email:                  example@serviceprovider.example.com.com
  tech_contact_email:             example@serviceprovider.example.com.com
  tech_contact_name:              Administrator


These should be set as Heroku config environment vars and then referenced when creating the ruby-saml-mod settings object.

    saml_settings = Onelogin::Saml::Settings.new
    saml_settings.issuer = ENV["issuer"]


The saml gem requires an ssl cert and key for use in the application. I made it available to the application and keep it from being committed and pushed to the public main repo by using a script that copies the keys, commits, pushes to Heroku, and finally rolls back the commit after the deploy.

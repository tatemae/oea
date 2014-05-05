oea
===

Open Embeddable Assessment

Notes
=====

deploy
======
run `bin/deploy` to deploy

oEmbed
======
OEA supports oembed for assessments. The oEmbed endpoint is located at '/oembed.json'. Pass the url of an assessment to get it's oEmbed representation.

Example when running the application locally:
  http://lvh.me:3000/oembed.json?url=http://lvh.me:3000/users/2/assessments/1

In production:
  http://www.openassessments.com/oembed.json?url=http://www.openassessments.com/users/2/assessments/1


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

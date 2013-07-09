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

  factory :assessment do
    identifier { FactoryGirl.generate(:identifier) }
    xml { open('./spec/fixtures/test.xml').read.gsub(/\s+/, ' ').strip }
  end

  # factory :section do
  #   identifier { FactoryGirl.generate(:identifier) }
  # end

  factory :item do
    identifier { FactoryGirl.generate(:identifier) }
    xml { open('./spec/fixtures/item.xml').read.gsub(/\s+/, ' ').strip }
  end

end

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
    title { FactoryGirl.generate(:name) }
  end

  factory :section do
    assessment
    identifier { FactoryGirl.generate(:identifier) }
  end

  factory :item do
    section
    identifier { FactoryGirl.generate(:identifier) }
    feedback "{\"Yellow\":[\"3389_fb\",\"correct_fb\"],\"yellow\":[\"9569_fb\",\"correct_fb\"],\"amarillo\":[\"4469_fb\",\"correct_fb\"],\"blue\":[\"correct_fb\"]}"
    item_feedback "{\"general_fb\":[\"That dude is old.\"],\"correct_fb\":[\"You stay on the bridge. Good job.\"],\"general_incorrect_fb\":[\"You were thrown off the bridge.\"],\"3389_fb\":[\"good\"],\"9569_fb\":[\"good again\"],\"4469_fb\":[\"spanish\"]}"
    correct_responses "[\"Yellow\",\"yellow\",\"amarillo\",\"blue\"]"
  end

  factory :assessment_result do

  end

  factory :item_result do
    item
    user
    assessment_result

    session_status { 'initial' }

  end

end

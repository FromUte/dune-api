FactoryGirl.define do
  factory :access_token, class: 'Neighborly::Api::AccessToken' do
    user
  end

  factory :user do
    name         'Joãozinho'
    password     'right-password'
    email        { "person#{rand}@example.com" }
    confirmed_at { Time.now }
  end
end

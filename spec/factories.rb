FactoryGirl.define do
  factory :user do
    name         'Joãozinho'
    password     'right-password'
    email        { "person#{rand}@example.com" }
    confirmed_at { Time.now }
  end
end

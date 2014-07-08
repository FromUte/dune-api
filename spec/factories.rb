FactoryGirl.define do
  factory :access_token, class: 'Neighborly::Api::AccessToken' do
    user
  end

  factory :category do
    name_pt { "category-#{rand}" }
  end

  factory :project do
    about    'a-big-text-about-the-project'
    goal     10_000
    headline 'attractive-headline'
    location 'New York, NY'
    name     'a-project'
    state    :online
    user
    category
  end

  factory :tag do
    name    { "subject-#{rand}" }
    visible true
  end

  factory :tag_popular, parent: :tag do
    after(:create) do |resource, evaluator|
      projects = create_list(:project, 4, state: :online)
      projects.map do |project|
        project.tags << resource
        project.save
      end
    end
  end

  factory :user do
    name         'Joãozinho'
    password     'right-password'
    email        { "person#{rand}@example.com" }
    confirmed_at { Time.now }
  end
end

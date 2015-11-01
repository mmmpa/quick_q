FactoryGirl.define do
  factory :qa_source_link, :class => 'Qa::SourceLink' do
    trait :valid do
      name { SecureRandom.hex(4) }
      url { SecureRandom.hex(16) }
    end
  end
end

FactoryGirl.define do
  factory :qa_tag, :class => 'Qa::Tag' do
    trait :valid do
      name { SecureRandom.hex(4) }
      display { SecureRandom.hex(4) }
    end
  end
end

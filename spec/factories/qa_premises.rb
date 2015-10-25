FactoryGirl.define do
  factory :qa_premise, :class => 'Qa::Premise' do
    trait :valid do
      text { SecureRandom.hex(4) }
    end
  end
end

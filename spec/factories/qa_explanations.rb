FactoryGirl.define do
  factory :qa_explanation, :class => 'Qa::Explanation' do
    trait :valid do
      question { create(:qa_question, :valid) }
      text { SecureRandom.hex(4) }
    end

    trait :valid_attr do
      text { SecureRandom.hex(4) }
    end
  end
end

FactoryGirl.define do
  factory :qa_correct_answer, :class => 'Qa::CorrectAnswer' do
    trait :valid do
      question { create(:qa_question, :valid) }
      text { SecureRandom.hex(4) }
    end
  end
end

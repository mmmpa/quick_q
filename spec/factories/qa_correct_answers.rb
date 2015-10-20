FactoryGirl.define do
  factory :qa_correct_answer, :class => 'Qa::CorrectAnswer' do
    trait :valid do
      question { create(:qa_question, :valid) }
      answer_option { create(:qa_answer_option, :valid) }
    end
  end
end

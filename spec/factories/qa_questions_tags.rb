FactoryGirl.define do
  factory :qa_questions_tag, :class => 'Qa::QuestionsTag' do
    trait :valid do
      question { create(:qa_question, :valid) }
      tag { create(:qa_tag, :valid) }
    end
  end

end

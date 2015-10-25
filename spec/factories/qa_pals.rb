FactoryGirl.define do
  factory :qa_pal, :class => 'Qa::Pal' do
    trait :valid do
      question { create(:qa_question, :valid) }
      premise { create(:qa_premise, :valid) }
    end
  end
end

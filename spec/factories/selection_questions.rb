FactoryGirl.define do
  factory :selection_question, :class => 'Selection::Question' do
    trait :valid do
      question { create(:qa_question, :valid) }
      selection { create(:selection_selection, :valid) }
    end
  end
end

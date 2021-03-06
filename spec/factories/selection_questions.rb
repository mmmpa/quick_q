FactoryGirl.define do
  factory :selection_selected_question, :class => 'Selection::SelectedQuestion' do
    trait :valid do
      question { create(:qa_question, :valid) }
      selection { create(:selection_selection, :valid) }
    end
  end
end

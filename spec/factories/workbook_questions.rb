FactoryGirl.define do
  factory :workbook_question, :class => 'Workbook::Question' do
    trait :valid do
      score { 1 }
      book { create(:workbook_book, :valid) }
      question { create(:qa_question, :valid) }
    end
  end
end

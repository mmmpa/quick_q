FactoryGirl.define do
  factory :qa_quote, :class => 'Qa::Quote' do
    trait :valid do
      question { create(:qa_question, :valid) }
      source_link { create(:qa_source_link, :valid) }
    end
  end
end

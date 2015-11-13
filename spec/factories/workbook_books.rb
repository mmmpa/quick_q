FactoryGirl.define do
  factory :workbook_book, :class => 'Workbook::Book' do
    trait :valid do
      name { SecureRandom.hex(4) }
      eval_type { 1 }
      passing { 1 }
    end
  end
end

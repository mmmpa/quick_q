FactoryGirl.define do
  factory :selection_selection, :class => 'Selection::Selection' do
    trait :valid do
      name { SecureRandom.hex(8) }
      choice_type { Selection::Selection.choice_types[:manual] }
    end
  end
end

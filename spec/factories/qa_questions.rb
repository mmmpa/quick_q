FactoryGirl.define do
  factory :qa_question, :class => 'Qa::Question' do
    trait :valid do
      text { SecureRandom.hex(4) }
      way { Qa::Question.ways[:choices] }
    end
  end

end

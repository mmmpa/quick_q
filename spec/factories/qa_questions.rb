FactoryGirl.define do
  factory :qa_question, :class => 'Qa::Question' do
    trait :valid do
      text { SecureRandom.hex(4) }
      way { Qa::Question.ways[:choice] }
      options { [
        {text: SecureRandom.hex(4), correct_answer: true},
        {text: SecureRandom.hex(4)},
        {text: SecureRandom.hex(4)},
        {text: SecureRandom.hex(4)},
      ] }
    end
  end
end

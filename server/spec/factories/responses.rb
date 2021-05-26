FactoryBot.define do
  factory :response do
    code { 203 }
    headers { { foo: 'bar' } }
  end
end

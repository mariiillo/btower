FactoryBot.define do
  factory :endpoint do
    verb { 0 }
    path { 'foo/bar/baz' }
    response
  end
end

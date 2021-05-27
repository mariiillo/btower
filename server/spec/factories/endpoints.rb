# frozen_string_literal: true

FactoryBot.define do
  factory :endpoint do
    verb { 'GET' }
    path { 'foo/bar/baz' }
    response do
      {
        "code": 200,
        "headers": {},
        "body": '"{ "message": "Hello, world" }"'
      }
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

describe Endpoint do
  context 'fields' do
    it { is_expected.to have_db_column(:verb).of_type(:string) }
    it { is_expected.to have_db_column(:path).of_type(:string) }
    it { is_expected.to have_db_column(:response).of_type(:jsonb) }
  end

  context 'validations' do
    subject { build(:endpoint) }

    it { is_expected.to validate_presence_of(:verb) }
    it { is_expected.to validate_presence_of(:response) }
    it { is_expected.to validate_presence_of(:path) }
    it { is_expected.to validate_uniqueness_of(:path) }

    describe 'validates response column' do
      it 'is invalid with invalid headers schema' do
        headers = "foo: 'bar'"
        response = { code: 200, headers: headers, body: 'some body' }
        endpoint = build(:endpoint, response: response)

        expect(endpoint).not_to be_valid
      end

      it 'is invalid without code' do
        headers = "foo: 'bar'"
        response = { headers: headers, body: 'some body' }
        endpoint = build(:endpoint, response: response)

        expect(endpoint).not_to be_valid
      end

      it 'is valid with valid data' do
        headers = { foo: 'bar' }
        response = { code: 200, headers: headers, body: 'some body' }
        endpoint = build(:endpoint, response: response)

        expect(endpoint).to be_valid
      end
    end
  end

  context 'after_create callback' do
    describe "#register_route" do
      it "register a new route based on the created endpoint" do

      end
    end
  end

  context 'after_destroy callback' do
    describe "#unregister_route" do

    end
  end
end

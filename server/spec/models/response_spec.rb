require 'rails_helper'

describe Response do
  context "fields" do
    it { is_expected.to have_db_column(:code).of_type(:integer) }
    it { is_expected.to have_db_column(:headers).of_type(:json) }
    it { is_expected.to have_db_column(:body).of_type(:string) }
  end

  context "associations" do
    it { is_expected.to belong_to(:endpoint) }
  end

  context "validations" do
    subject { build(:response) }

    it { is_expected.to validate_presence_of(:code) }
    it { is_expected.to validate_presence_of(:endpoint) }
  end
end

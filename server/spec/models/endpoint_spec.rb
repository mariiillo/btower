require 'rails_helper'

describe Endpoint do
  context "fields" do
    it { is_expected.to have_db_column(:verb).of_type(:integer) }
    it { is_expected.to have_db_column(:path).of_type(:string) }
  end

  context "associations" do
    it { is_expected.to have_one(:response) }
  end

  context "validations" do
    subject { create(:endpoint) }
    it { is_expected.to validate_presence_of(:verb) }
    it { is_expected.to validate_presence_of(:path) }
    it { is_expected.to validate_uniqueness_of(:path) }
  end
end

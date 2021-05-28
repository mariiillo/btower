# frozen_string_literal: trues

require 'rails_helper'

describe Server::Router do
  describe '.load_endpoint_routes!' do
    it 'does nothing if endpoints table does not exist' do
      connection = double
      allow(connection).to receive(:table_exists?).with('endpoints').and_return(false)
      allow(ActiveRecord::Base).to receive(:connection).and_return(connection)

      expect(described_class).not_to receive(:define_route)
    end

    it 'should define routes for current endpoints' do
      3.times do |i|
        build_stubbed(:endpoint, path: "/foo/#{i}")
      end

      Endpoint.find_each do |endpoint|
        expect(described_class).to receive(:define_route).with(endpoint)
      end

      described_class.load_endpoint_routes!
    end
  end
end

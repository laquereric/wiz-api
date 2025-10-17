# frozen_string_literal: true

require "spec_helper"

RSpec.describe Wiz::Client do
  let(:client_id) { "test_client_id" }
  let(:client_secret) { "test_client_secret" }
  let(:api_endpoint) { "https://api.us1.app.wiz.io/graphql" }

  describe "#initialize" do
    context "with direct parameters" do
      it "initializes a client with the given parameters" do
        client = Wiz::Client.new(
          client_id: client_id,
          client_secret: client_secret,
          api_endpoint: api_endpoint
        )

        expect(client.config.client_id).to eq(client_id)
        expect(client.config.client_secret).to eq(client_secret)
        expect(client.config.api_endpoint).to eq(api_endpoint)
      end

      it "raises an error if required parameters are missing" do
        expect { Wiz::Client.new(client_id: client_id) }.to raise_error(Wiz::ConfigurationError)
      end
    end

    context "with global configuration" do
      before do
        Wiz.configure do |config|
          config.client_id = client_id
          config.client_secret = client_secret
          config.api_endpoint = api_endpoint
        end
      end

      it "initializes a client with the global configuration" do
        client = Wiz::Client.new
        expect(client.config.client_id).to eq(client_id)
        expect(client.config.client_secret).to eq(client_secret)
        expect(client.config.api_endpoint).to eq(api_endpoint)
      end
    end
  end

  describe "resource accessors" do
    let(:client) do
      Wiz::Client.new(
        client_id: client_id,
        client_secret: client_secret,
        api_endpoint: api_endpoint
      )
    end

    it "returns an Issues resource client" do
      expect(client.issues).to be_a(Wiz::Resources::Issues)
    end

    it "returns a Vulnerabilities resource client" do
      expect(client.vulnerabilities).to be_a(Wiz::Resources::Vulnerabilities)
    end

    it "returns an Assets resource client" do
      expect(client.assets).to be_a(Wiz::Resources::Assets)
    end
  end

  describe "#query and #mutate" do
    let(:client) do
      Wiz::Client.new(
        client_id: client_id,
        client_secret: client_secret,
        api_endpoint: api_endpoint
      )
    end
    let(:query) { "query { projects { nodes { id } } }" }
    let(:response_body) { { "data" => { "projects" => { "nodes" => [{ "id" => "1" }] } } }.to_json }

    before do
      allow(client.auth).to receive(:access_token).and_return("test_token")
      stub_request(:post, api_endpoint).to_return(status: 200, body: response_body)
    end

    it "executes a custom query" do
      response = client.query(query)
      expect(response).to eq(JSON.parse(response_body)["data"])
    end

    it "executes a custom mutation" do
      response = client.mutate(query)
      expect(response).to eq(JSON.parse(response_body)["data"])
    end
  end
end


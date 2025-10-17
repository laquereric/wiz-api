# frozen_string_literal: true

require "spec_helper"

RSpec.describe Wiz::Auth, :vcr do
  let(:client_id) { ENV["WIZ_CLIENT_ID"] || "test_client_id" }
  let(:client_secret) { ENV["WIZ_CLIENT_SECRET"] || "test_client_secret" }
  let(:auth_url) { "https://auth.app.wiz.io/oauth/token" }
  let(:config) do
    Wiz::Configuration.new.tap do |c|
      c.client_id = client_id
      c.client_secret = client_secret
      c.auth_url = auth_url
    end
  end
  let(:auth) { Wiz::Auth.new(config) }

  describe "#access_token" do
    it "fetches a new access token" do
      token = auth.access_token
      expect(token).not_to be_nil
      expect(auth.token_valid?).to be true
    end

    it "uses a cached token if valid" do
      first_token = auth.access_token
      second_token = auth.access_token
      expect(first_token).to eq(second_token)
    end

    it "refreshes an expired token" do
      auth.access_token
      allow(auth).to receive(:token_valid?).and_return(false)
      expect(auth).to receive(:fetch_access_token).and_call_original
      auth.access_token
    end

    it "raises an error on authentication failure" do
      config.client_secret = "invalid_secret"
      expect { auth.access_token }.to raise_error(Wiz::AuthenticationError)
    end
  end
end


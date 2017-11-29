require 'spec_helper'

RSpec.describe ImageFlux::Origin do
  let(:domain) { FFaker::Internet.domain_name }
  subject(:origin) { described_class.new(domain: domain) }

  describe "#base_url" do
    subject(:base_url) { origin.base_url }

    it { is_expected.to be_a(URI::HTTPS) }
    it { expect(base_url.host).to eq(domain) }
    it { expect(base_url.path).to eq('/') }
  end
end

# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ImageFlux::Origin do
  let(:domain) { FFaker::Internet.domain_name }
  subject(:origin) { described_class.new(domain: domain) }

  describe '#base_url' do
    subject(:base_url) { origin.base_url }

    it { is_expected.to be_a(URI::HTTPS) }
    it { expect(base_url.host).to eq(domain) }
    it { expect(base_url.path).to eq('/') }
  end

  describe '#image_url' do
    let(:path) { '/image.jpg' }
    let(:options) { { w: 100 } }
    subject(:image_url) { origin.image_url(path, options) }

    it { is_expected.to be_a(URI::HTTPS) }
    it { expect(image_url.path).to eq('/c/w=100/image.jpg') }

    context 'with prefix path' do
      let(:options) { { prefix: '/small', w: 100 } }

      it { expect(image_url.path).to eq('/c/w=100/small/image.jpg') }
    end

    context 'with signature path' do
      let(:secret) { SecureRandom.hex }
      subject(:origin) { described_class.new(domain: domain, signing_secret: secret) }

      it {
        hash = OpenSSL::HMAC.digest('sha256', secret, '/c/w=100/image.jpg')
        expect(image_url.path).to eq("/c/w=100,sig=1.#{Base64.urlsafe_encode64(hash)}/image.jpg")
      }
    end
  end
end

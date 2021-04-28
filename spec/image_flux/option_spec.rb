# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ImageFlux::Option do
  subject(:option) { described_class.new(width: 100, o: false, r: 'auto', f: 'png', a: :crop, t: 'gif') }

  describe 'getter' do
    it 'should get attribute value' do
      expect(option.width).to eq(100)
    end
  end

  describe 'setter' do
    it 'should set attribute value' do
      option.width = 200
      expect(option.width).to eq(200)
    end
  end

  describe '#to_query' do
    subject(:to_query) { option.to_query }

    it { is_expected.to eq('w=100,o=0,r=auto,f=png,a=2,t=gif') }

    it 'should raise error with invalid unsharp format' do
      option.unsharp = 'foo'

      expect { option.to_query }.to raise_error(ImageFlux::InvalidOptionError)
    end

    it 'should have multiple overlay' do
      option.overlay = [
        { h: 200, y: 800, path: '/dev/harukasan.png' },
        { w: 300, x: 200, path: '/dev/usa.png' }
      ]

      expect(option.to_query).to eq('w=100,o=0,r=auto,f=png,a=2,t=gif,l=(h=200,y=800%2Fdev%2Fharukasan.png),l=(w=300,x=200%2Fdev%2Fusa.png)')
    end
  end
end

# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ImageFlux::Option do
  subject(:option) { described_class.new(width: 100, o: false, f: 'png', a: :crop, t: 'gif') }

  describe '#to_query' do
    subject(:to_query) { option.to_query }

    it { is_expected.to eq('w=100,o=0,f=png,a=2,t=gif') }
  end
end

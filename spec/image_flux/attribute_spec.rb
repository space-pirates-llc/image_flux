# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ImageFlux::Attribute do
  context 'with string value' do
    subject(:attribute) do
      ImageFlux::Attribute.new(:attr, :string)
    end

    describe '#validate!' do
      it 'should raise error on invalid value' do
        errors = attribute.validate!(1)
        expect(errors.size).to eq(0)

        attribute.validate do |_val|
          'Always raise error'
        end

        errors = attribute.validate!(1)
        expect(errors.size).to eq(1)
      end
    end
  end

  context 'with integer value' do
    subject(:attribute) do
      ImageFlux::Attribute.new(:attr, :integer)
    end

    describe '#validate!' do
      it 'should raise error on invalid value' do
        errors = attribute.validate!(Object.new)
        expect(errors.size).to eq(1)
      end
    end
  end

  context 'with float value' do
    subject(:attribute) do
      ImageFlux::Attribute.new(:attr, :float)
    end

    describe '#validate!' do
      it 'should raise error on invalid value' do
        errors = attribute.validate!(Object.new)
        expect(errors.size).to eq(1)
      end
    end
  end

  context 'with float value' do
    subject(:attribute) do
      ImageFlux::Attribute.new(:attr, :integer_array)
    end

    describe '#validate!' do
      it 'should raise error on invalid value' do
        errors = attribute.validate!(1)
        expect(errors.size).to eq(1)
      end
    end
  end

  context 'with integer_array value' do
    subject(:attribute) do
      ImageFlux::Attribute.new(:attr, :integer_array)
    end

    describe '#validate!' do
      it 'should raise error on invalid value' do
        errors = attribute.validate!(1)
        expect(errors.size).to eq(1)
      end
    end
  end

  context 'with float_array value' do
    subject(:attribute) do
      ImageFlux::Attribute.new(:attr, :float_array)
    end

    describe '#validate!' do
      it 'should raise error on invalid value' do
        errors = attribute.validate!(1)
        expect(errors.size).to eq(1)
      end
    end
  end

  context 'with boolean value' do
    subject(:attribute) do
      ImageFlux::Attribute.new(:attr, :boolean)
    end

    describe '#validate!' do
      it 'should raise error on invalid value' do
        errors = attribute.validate!(1)
        expect(errors.size).to eq(1)
      end
    end
  end

  describe '#querize' do
    [
      [:string, 'a/b', 'a/b'],
      [:integer, 1, '1'],
      [:float, 0.57, '0.57'],
      [:integer_array, [1, 2, 3], '1:2:3'],
      [:float_array, [0.1, 0.2, 0.3], '0.1:0.2:0.3'],
      [:boolean, true, '1'],
      [:boolean, false, '0'],
      [:unknown, 0, '0']
    ].each do |type, value, expect|
      it "should convert #{value} to #{expect} on #{type} type" do
        attribute = ImageFlux::Attribute.new(:querize_test, type)

        expect(attribute.querize(value)).to eq("querize_test=#{expect}")
      end
    end
  end
end

require "rails_helper"

RSpec.describe "Attack", type: :model do
  describe '.reward_for' do
    describe 'gauge between 0 and 9' do
      it 'returns nil if gauge is 0' do
        expect(Strike.reward_for(0)).to eq(nil)
      end

      it 'returns nil if gauge is 9' do
        expect(Strike.reward_for(9)).to eq(nil)
      end
    end

    describe 'gauge between 10 and 24' do
      it 'returns hyperdrive if gauge is 10' do
        expect(Strike.reward_for(10)).to eq(:hyperdrive)
      end

      it 'returns hyperdrive if gauge is 24' do
        expect(Strike.reward_for(24)).to eq(:hyperdrive)
      end
    end

    describe 'gauge between 25 and 44' do
      it 'returns jammer if gauge is 25' do
        expect(Strike.reward_for(25)).to eq(:jammer)
      end

      it 'returns jammer if gauge is 44' do
        expect(Strike.reward_for(44)).to eq(:jammer)
      end
    end

    describe 'gauge between 45 and 69' do
      it 'returns gauge_leak if gauge is 45' do
        expect(Strike.reward_for(45)).to eq(:gauge_leak)
      end

      it 'returns gauge_leak if gauge is 69' do
        expect(Strike.reward_for(69)).to eq(:gauge_leak)
      end
    end

    describe 'gauge between 70 and 99' do
      it 'returns enlarger if gauge is 70' do
        expect(Strike.reward_for(70)).to eq(:enlarger)
      end

      it 'returns enlarger if gauge is 99' do
        expect(Strike.reward_for(99)).to eq(:enlarger)
      end
    end

    describe 'gauge is 100' do
      it 'returns saboteur' do
        expect(Strike.reward_for(100)).to eq(:saboteur)
      end
    end
  end
end

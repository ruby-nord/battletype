require "rails_helper"

RSpec.describe "Attack", type: :model do
  subject(:attack)  { Attack.new(word) }
  let(:word)        { 'attack' }

  describe '#valid?' do
    it 'always returns true' do
      expect(attack.valid?).to eq(true)
    end
  end
end

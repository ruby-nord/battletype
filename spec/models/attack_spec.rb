require "rails_helper"

RSpec.describe "Attack", type: :model do
  subject(:attack)  { Attack.new(game, word) }
  let(:game)        { Game.create! }
  let(:word)        { 'attack' }

  describe '#valid?' do
    context 'when word has never been played' do
      it 'returns true' do
        expect(attack.valid?).to eq(true)
      end
    end

    context 'when word has already been played' do
      before :each do
        Word.create!(value: word, game: game)
      end

      it 'returns false' do
        expect(attack.valid?).to eq(false)
      end
    end
  end
end

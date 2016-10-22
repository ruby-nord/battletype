require "rails_helper"

RSpec.describe "Defense", type: :model do
  subject(:defense)     { Defense.new(player: player, word: word, perfect_typing: perfect_typing) }

  let(:game)            { Game.create! }
  let(:attacker)        { Player.create!(game: game) }
  let(:attacker_word)   { Word.create!(value: 'HaCkeR', game: game) }
  let(:perfect_typing)  { '1' }
  let(:player)          { Player.create!(game: game) }

  before :each do
    attacker.ships.create!(word: attacker_word, state: 'engaged')
  end

  describe '#strike_gauge' do
    let(:word) { 'strike' }

    before :each do
      player.strike_gauge = 5
    end

    context 'when word is perfectly typed' do
      it 'returns 11' do
        expect(defense.strike_gauge).to eq(11)
      end
    end

    context 'when gauge will exceed 100' do
      before :each do
        player.strike_gauge = 95
      end

      it 'returns 100' do
        expect(defense.strike_gauge).to eq(100)
      end
    end

    context 'when word is not perfectly typed' do
      let(:perfect_typing) { '0' }

      it 'returns 0' do
        expect(defense.strike_gauge).to eq(0)
      end
    end
  end

  describe '#valid?' do
    context "when word does not match any attacker ship" do
      let(:word) { 'unknown' }

      it 'returns false' do
        expect(defense.valid?).to eq(false)
      end
    end

    context "when word matches player's own ship" do
      let(:word) { 'own' }

      it 'returns false' do
        expect(defense.valid?).to eq(false)
      end
    end

    context "when word matches one of attacker's ships with wrong case" do
      let(:word) { 'hacker' }

      it 'returns false' do
        expect(defense.valid?).to eq(false)
      end
    end

    context "when word matches one of attacker's ships" do
      let(:word) { 'HaCkeR' }

      it 'returns true' do
        expect(defense.valid?).to eq(true)
      end
    end
  end
end

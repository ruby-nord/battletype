require "rails_helper"

RSpec.describe "Bomb", type: :model do
  subject(:bomb) { Bomb.new(player: attacker, word: word) }

  let(:game)            { Game.create!(state: 'running') }
  let(:attacker)        { Player.create!(game: game) }
  let(:attacker_word)   { Word.create!(value: 'BOMB', game: game) }
  let(:perfect_typing)  { '1' }
  let(:player)          { Player.create!(game: game) }
  let(:player_word)     { Word.create!(value: 'own', game: game) }
  let(:word)            { attacker_word.value }

  before :each do
    attacker.ships.create!(word: attacker_word, state: 'engaged')
    player.ships.create!(word: player_word, state: 'engaged')
  end

  describe '#ship' do
    context "when word does not match any ship" do
      let(:word) { 'unknown' }

      it 'returns nil' do
        expect(bomb.ship).to eq(nil)
      end
    end

    context "when word matches a ship case insensitive" do
      let(:word) { 'hacker' }

      it "returns nil" do
        expect(bomb.ship).to eq(nil)
      end
    end

    context "when word matches a ship case sensitive" do
      let(:word) { 'BOMB' }

      it "returns the ship" do
        expect(bomb.ship).to eq(game.ships.where(player: attacker).first)
      end
    end
  end

  describe '#valid?' do
    context "when word does not match any attacker ship" do
      let(:word) { 'unknown' }

      it 'returns false' do
        expect(bomb.valid?).to eq(false)
      end
    end

    context "when word matches attacked player's own ship" do
      let(:word) { 'own' }

      it 'returns false' do
        expect(bomb.valid?).to eq(false)
      end
    end

    context "when word matches one of attacker's ships" do
      let(:word) { 'BOMB' }

      it 'returns true' do
        expect(bomb.valid?).to eq(true)
      end
    end

    context "when game is finished" do
      let(:word) { 'BOMB' }

      before :each do
        game.update(state: 'finished')
      end

      it 'returns false' do
        expect(bomb.valid?).to eq(false)
      end
    end
  end
end

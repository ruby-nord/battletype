require "rails_helper"

RSpec.describe "Defense", type: :model do
  subject(:defense)     { Defense.new(player: player, word: word, perfect_typing: perfect_typing) }

  let(:game)            { Game.create!(state: 'running') }
  let(:attacker)        { Player.create!(game: game) }
  let(:attacker_word)   { Word.create!(value: 'HaCkeR', game: game) }
  let(:perfect_typing)  { '1' }
  let(:player)          { Player.create!(game: game) }
  let(:player_word)     { Word.create!(value: 'own', game: game) }
  let(:word)            { attacker_word.value }

  before :each do
    attacker.ships.create!(word: attacker_word, state: 'engaged')
    player.ships.create!(word: player_word, state: 'engaged')
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

  describe '#unlocked_strike' do
    let(:word) { '' } # fake it to have direct strike_gauge from player

    describe 'strike gauge between 10 and 24' do
      it 'returns hyperdrive if gauge is 10' do
        player.strike_gauge = 10
        expect(defense.unlocked_strike).to eq(:hyperdrive)
      end

      it 'returns hyperdrive if gauge is 24' do
        player.strike_gauge = 24
        expect(defense.unlocked_strike).to eq(:hyperdrive)
      end

      it 'remains jammer if unlocked' do
        player.unlocked_strike = 'jammer'
        expect(defense.unlocked_strike).to eq('jammer')
      end

      it 'remains gauge_leak if unlocked' do
        player.unlocked_strike = 'gauge_leak'
        expect(defense.unlocked_strike).to eq('gauge_leak')
      end

      it 'remains enlarger if unlocked' do
        player.unlocked_strike = 'enlarger'
        expect(defense.unlocked_strike).to eq('enlarger')
      end

      it 'remains saboteur if unlocked' do
        player.unlocked_strike = 'saboteur'
        expect(defense.unlocked_strike).to eq('saboteur')
      end
    end
  end

  describe '#ship' do
    context "when word does not match any ship" do
      let(:word) { 'unknown' }

      it 'returns nil' do
        expect(defense.ship).to eq(nil)
      end
    end

    context "when word matches a ship case insensitive" do
      let(:word) { 'hacker' }

      it "returns the ship" do
        expect(defense.ship).to eq(game.ships.where(player: attacker).first)
      end
    end

    context "when word matches a ship case sensitive" do
      let(:word) { 'HaCkeR' }

      it "returns the ship" do
        expect(defense.ship).to eq(game.ships.where(player: attacker).first)
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

    context "when word matches a ship that is already destroyed" do
      before :each do
        attacker.ships.last.update(state: 'destroyed')
      end

      it 'returns false' do
        expect(defense.valid?).to eq(false)
      end
    end

    context "when word matches a ship that already accomplissed its mission" do
      before :each do
        attacker.ships.last.update(state: 'mission_accomplished')
      end

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

    context 'when game is finished' do
      before :each do
        game.update(state: 'finished')
      end

      it 'returns false' do
        expect(defense.valid?).to eq(false)
      end
    end
  end
end

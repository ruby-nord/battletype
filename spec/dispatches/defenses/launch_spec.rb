require "rails_helper"

RSpec.describe "Defenses::Launch", type: :dispatch do
  subject(:dispatch)  { Defenses::Launch }

  let(:game)          { Game.create! }
  let(:attacker)      { Player.create!(game: game) }
  let(:attacker_ship) { attacker.ships.last }
  let(:attacker_word) { Word.create!(value: 'attacker', game: game) }
  let(:player)        { Player.create!(game: game) }

  before :each do
    attacker.ships.create!(word: attacker_word, state: 'engaged')
  end

  describe ".call" do
    context "when defense is valid" do
      let(:word) { 'attacker' }

      it "marks attacker's ship as destroyed" do
        dispatch.call(player: player, word: word, perfect_typing: '1')
        expect(attacker_ship.state).to eq('destroyed')
      end

      it 'returns a Defense object' do
        expect(dispatch.call(player: player, word: word, perfect_typing: '1')).to be_instance_of(Defense)
      end

      context "when word was perfectly typed" do
        before :each do
          player.strike_gauge = 3
        end

        it "upgrades player strike gauge" do
          expect { dispatch.call(player: player, word: word, perfect_typing: '1') }.to change { player.strike_gauge }.from(3).to(11)
        end
      end

      context "when word was not perfectly typed" do
        before :each do
          player.strike_gauge = 5
        end

        it "resets player strike gauge to 0" do
          expect { dispatch.call(player: player, word: word, perfect_typing: '0') }.to change { player.strike_gauge }.from(5).to(0)
        end
      end
    end

    context "when defense is not valid" do
      let(:word) { 'unknown' }

      it "does not match any attacker's ship as destroyed" do
        dispatch.call(player: player, word: word, perfect_typing: '1')
        expect(attacker_ship.state).to eq('engaged')
      end

      it 'returns a Defense object' do
        expect(dispatch.call(player: player, word: word, perfect_typing: '1')).to be_instance_of(Defense)
      end
    end
  end
end

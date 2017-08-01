require "rails_helper"

RSpec.describe "Defenses::Launch", type: :dispatch do
  subject(:dispatch)  { Defenses::Launch }

  let(:game)          { Game.create!(state: 'running') }
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

      it "marks attacker's ship as down" do
        dispatch.call(player: player, word: word, perfect_typing: '1')
        expect(attacker_ship.state).to eq('down')
      end

      it 'returns a payload' do
        expect(dispatch.call(player: player, word: word, perfect_typing: '1')).to be_instance_of(Hash)
      end

      it 'returns a successful payload with strike infos' do
        expect(dispatch.call(player: player, word: word, perfect_typing: '1')).to include(
          code:       'successful_defense',
          player_id:  player.id,
          word:       word,
          strike: {
            gauge:    8,
            unlocked: nil
          }
        )
      end

      context "when word was perfectly typed" do
        before :each do
          player.strike_gauge    = 17
          player.unlocked_strike = 'hyperdrive'
        end

        it "upgrades player strike gauge" do
          expect { dispatch.call(player: player, word: word, perfect_typing: '1') }.to change { player.strike_gauge }.from(17).to(25)
        end

        it "bumps player unlocked strike" do
          expect { dispatch.call(player: player, word: word, perfect_typing: '1') }.to change { player.unlocked_strike }.from('hyperdrive').to('jammer')
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

      it 'returns a payload' do
        expect(dispatch.call(player: player, word: word, perfect_typing: '1')).to be_instance_of(Hash)
      end

      it 'returns a failed payload with error infos' do
        expect(dispatch.call(player: player, word: word, perfect_typing: '1')).to include(
          code:       'failed_defense',
          player_id:  player.id,
          word:       word,
          error_codes: ['ship_not_found']
        )
      end
    end
  end
end

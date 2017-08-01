require "rails_helper"

RSpec.describe "Bombs::Drop", type: :dispatch do
  subject(:dispatch)    { Bombs::Drop }

  let(:game)            { Game.create!(state: 'running') }
  let(:attacked_player) { Player.create!(game: game, life: 10) }
  let(:attacked_word)   { Word.create!(game: game, value: 'go') }
  let(:attacker)        { Player.create!(game: game) }
  let(:attacker_word)   { Word.create!(game: game, value: 'BOMB') }
  let(:ship)            { attacker.ships.last }
  let(:word)            { 'BOMB' }

  before :each do
    attacker.ships.create!(word: attacker_word, state: 'engaged', damage: 2)
    attacked_player.ships.create!(word: attacked_word, state: 'engaged', damage: 1)
  end

  describe '.call' do
    context 'when word is valid' do
      it 'updates ship state to mission accomplished' do
        dispatch.call(player: attacker, word: word)
        expect(ship.reload.state).to eq('mission_accomplished')
      end

      it 'decreases life of attacked player' do
        dispatch.call(player: attacker, word: word)
        expect(attacked_player.reload.life).to eq(8)
      end

      it 'returns an Array of payloads' do
        expect(dispatch.call(player: attacker, word: word)).to all(be_an(Hash))
      end

      it 'returns 1 payload' do
        expect(dispatch.call(player: attacker, word: word).count).to eq(1)
      end

      it 'returns a successful payload with attacked player infos' do
        payload = dispatch.call(player: attacker, word: word).first

        expect(payload).to eq({
          code:       'successful_bombing',
          player_id:  attacker.id,
          word:       'BOMB',
          bombed_mothership: {
            life:             8,
            strike_gauge:     0,
            unlocked_strike:  nil
          }
        })
      end

      context 'when attacked player has strike gauge' do
        before :each do
          attacked_player.update(strike_gauge: 42)
        end

        it 'resets stirke gauge' do
          dispatch.call(player: attacker, word: word)
          expect(attacked_player.reload.strike_gauge).to eq(0)
        end

        it 'returns a successful payload with no strike gauge anymore' do
          payload = dispatch.call(player: attacker, word: word).first

          expect(payload).to eq({
            code:       'successful_bombing',
            player_id:  attacker.id,
            word:       'BOMB',
            bombed_mothership: {
              life:             8,
              strike_gauge:     0,
              unlocked_strike:  nil
            }
          })
        end
      end

      context 'when attacked player has unlocked strike' do
        before :each do
          attacked_player.update(unlocked_strike: 'saboteur')
        end

        it 'keeps the unlocked stirke' do
          dispatch.call(player: attacker, word: word)
          expect(attacked_player.reload.unlocked_strike).to eq('saboteur')
        end

        it 'returns a successful payload with the existing strike' do
          payload = dispatch.call(player: attacker, word: word).first

          expect(payload).to eq({
            code:       'successful_bombing',
            player_id:  attacker.id,
            word:       'BOMB',
            bombed_mothership: {
              life:             8,
              strike_gauge:     0,
              unlocked_strike:  'saboteur'
            }
          })
        end
      end

      context 'when attacked player is running short on life' do
        before :each do
          attacked_player.update(life: 1)
        end

        it 'sets player life to 0' do
          dispatch.call(player: attacker, word: word)
          expect(attacked_player.reload.life).to eq(0)
        end

        it 'sets attacker as winner' do
          dispatch.call(player: attacker, word: word)
          expect(attacker.won).to eq(true)
        end

        it 'finishes the game' do
          dispatch.call(player: attacker, word: word)
          expect(game.state).to eq('finished')
        end

        it 'returns 2 payloads' do
          expect(dispatch.call(player: attacker, word: word).count).to eq(2)
        end

        it 'returns a successful payload with no life anymore' do
          payload = dispatch.call(player: attacker, word: word).first

          expect(payload).to eq({
            code:       'successful_bombing',
            player_id:  attacker.id,
            word:       'BOMB',
            bombed_mothership: {
              life:             0,
              strike_gauge:     0,
              unlocked_strike:  nil
            }
          })
        end

        it 'returns a game won payload' do
          payload = dispatch.call(player: attacker, word: word).last

          expect(payload).to eq({
            code:       'game_won',
            player_id:  attacker.id,
          })
        end
      end

# - CHANGE state to won (true)
    end

    context 'when word is not valid' do
      let(:word) { 'unknown' }

      it 'does not update ship state' do
        dispatch.call(player: attacker, word: word)
        expect(ship.reload.state).to eq('engaged')
      end

      it 'does not decrease life of attacked player' do
        dispatch.call(player: attacker, word: word)
        expect(attacked_player.life).to eq(10)
      end

      it 'returns an Array of payloads' do
        expect(dispatch.call(player: attacker, word: word)).to all(be_an(Hash))
      end

      it 'returns 1 payload' do
        expect(dispatch.call(player: attacker, word: word).count).to eq(1)
      end

      it 'returns a failed payload with attacked player infos' do
        payload = dispatch.call(player: attacker, word: word).first

        expect(payload).to eq({
          code:         'failed_bombing',
          player_id:    attacker.id,
          word:         'unknown',
          error_codes:  ['ship_not_found']
        })
      end
    end
  end
end

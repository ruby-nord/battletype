require "rails_helper"

RSpec.describe "Bombings", type: :request do
  let(:game)            { Game.create!(name: 'Starship Battle', state: 'running') }
  let(:attacked_player) { Player.create!(game: game, life: 10) }
  let(:attacked_word)   { Word.create!(game: game, value: 'go') }
  let(:attacker)        { Player.create!(game: game, life: 7) }
  let(:attacker_word)   { Word.create!(value: 'BOMB') }
  let(:ship)            { game.ships.last }

  before :each do
    allow_any_instance_of(ApplicationController).to receive(:current_player).and_return(attacked_player)

    attacker.ships.create!(word: attacker_word, state: 'engaged', damage: 2)
    attacked_player.ships.create!(word: attacked_word, state: 'engaged', damage: 1)
  end

  describe "POST create" do
    context "when no word is provided" do
      it "returns 422 HTTP status" do
        post "/bombings"
        expect(response).to have_http_status(422)
      end
    end

    context "when word does not match any attacker ship" do
      it "returns 200 HTTP status" do
        post "/bombings", params: { word: 'unknown' }
        expect(response).to have_http_status(200)
      end

      it 'broadcasts a failed bombing payload' do
        allow(ActionCable.server).to receive(:broadcast)
        post "/bombings", params: { word: 'unknown' }

        expect(ActionCable.server).to have_received(:broadcast).with(
          anything,
          {
            code:         'failed_bombing',
            player_id:    attacker.id,
            word:         'unknown',
            error_codes:  ['ship_not_found']
          }
        )
      end
    end

    context "when word matches an attacker ship" do
      it "returns 200 HTTP status" do
        post "/bombings", params: { word: 'BOMB' }
        expect(response).to have_http_status(200)
      end

      it 'broadcasts a successful bombing payload' do
        allow(ActionCable.server).to receive(:broadcast)
        post "/bombings", params: { word: 'BOMB' }

        expect(ActionCable.server).to have_received(:broadcast).with(
          anything,
          {
            code:       'successful_bombing',
            player_id:  attacker.id,
            word:       'BOMB',
            bombed_mothership: {
              life:             8,
              strike_gauge:     0,
              unlocked_strike:  nil
            }
          }
        )
      end
    end

    context "when attacked player has strike gauge" do
      before :each do
        attacked_player.update(strike_gauge: 23)
      end

      it "returns 200 HTTP status" do
        post "/bombings", params: { word: 'BOMB' }
        expect(response).to have_http_status(200)
      end

      it 'broadcasts a successful bombing payload with no strike gauge anymore' do
        allow(ActionCable.server).to receive(:broadcast)
        post "/bombings", params: { word: 'BOMB' }

        expect(ActionCable.server).to have_received(:broadcast).with(
          anything,
          {
            code:       'successful_bombing',
            player_id:  attacker.id,
            word:       'BOMB',
            bombed_mothership: {
              life:             8,
              strike_gauge:     0,
              unlocked_strike:  nil
            }
          }
        )
      end
    end

    context "when attacked player has unlocked strike" do
      before :each do
        attacked_player.update(unlocked_strike: 'jammer')
      end

      it "returns 200 HTTP status" do
        post "/bombings", params: { word: 'BOMB' }
        expect(response).to have_http_status(200)
      end

      it 'broadcasts a successful bombing payload with still the unlocked strike' do
        allow(ActionCable.server).to receive(:broadcast)
        post "/bombings", params: { word: 'BOMB' }

        expect(ActionCable.server).to have_received(:broadcast).with(
          anything,
          {
            code:       'successful_bombing',
            player_id:  attacker.id,
            word:       'BOMB',
            bombed_mothership: {
              life:             8,
              strike_gauge:     0,
              unlocked_strike:  'jammer'
            }
          }
        )
      end
    end

    context "when attacked player is running short on life" do
      before :each do
        attacked_player.update(life: 1)
      end

      it "returns 200 HTTP status" do
        post "/bombings", params: { word: 'BOMB' }
        expect(response).to have_http_status(200)
      end

      it 'broadcasts successful bombing and game won payloads' do
        allow(ActionCable.server).to receive(:broadcast)
        post "/bombings", params: { word: 'BOMB' }

        expect(ActionCable.server).to have_received(:broadcast).with(
          anything,
          {
            code:       'successful_bombing',
            player_id:  attacker.id,
            word:       'BOMB',
            bombed_mothership: {
              life:             0,
              strike_gauge:     0,
              unlocked_strike:  nil
            }
          }
        )
        expect(ActionCable.server).to have_received(:broadcast).with(
          anything,
          {
            code:       'game_won',
            player_id:  attacker.id
          }
        )
      end
    end

    context "when game is finished" do
      before :each do
        game.update(state: 'finished')
      end

      it "returns 200 HTTP status" do
        post "/bombings", params: { word: 'BOMB' }
        expect(response).to have_http_status(200)
      end

      it 'broadcasts a failed bombing payload' do
        allow(ActionCable.server).to receive(:broadcast)
        post "/bombings", params: { word: 'BOMB' }

        expect(ActionCable.server).to have_received(:broadcast).with(
          anything,
          {
            code:         'failed_bombing',
            player_id:    attacker.id,
            word:         'BOMB',
            error_codes:  ['not_running']
          }
        )
      end
    end
  end
end

require "rails_helper"

RSpec.describe "Defenses", type: :request do
  let(:game)      { Game.create!(name: 'Starship Battle', state: 'running') }
  let(:attacker)  { game.players.create! }
  let(:player)    { game.players.create! }

  before :each do
    allow_any_instance_of(ApplicationController).to receive(:current_player).and_return(player)
  end

  describe "POST create" do
    context "when no word is provided" do
      it "returns 422 HTTP status" do
        post "/defenses"
        expect(response).to have_http_status(422)
      end
    end

    context "when word does not match any attacker ship" do
      it "returns 200 HTTP status" do
        post "/defenses", params: { word: 'unknown', perfect_typing: '1' }
        expect(response).to have_http_status(200)
      end

      it 'broadcasts a failed defense payload' do
        allow(ActionCable.server).to receive(:broadcast)
        post "/defenses", params: { word: 'unknown' }
        expect(ActionCable.server).to have_received(:broadcast).with(
          anything,
          {
            code:        'failed_defense',
            player_id:   player.id,
            word:        'unknown',
            error_codes: ['ship_not_found']
          }
        )
      end
    end

    context "when word matches player's own ship" do
      before :each do
        own_word = Word.create!(value: 'own')
        player.ships.create!(word: own_word)
      end

      it "returns 200 HTTP status" do
        post "/defenses", params: { word: 'own', perfect_typing: '1' }
        expect(response).to have_http_status(200)
      end

      it 'broadcasts a failed defense payload' do
        allow(ActionCable.server).to receive(:broadcast)
        post "/defenses", params: { word: 'own' }
        expect(ActionCable.server).to have_received(:broadcast).with(
          anything,
          {
            code:        'failed_defense',
            player_id:   player.id,
            word:        'own',
            error_codes: ['player_ship']
          }
        )
      end
    end

    context "when word matches one of attacker's ships with wrong case" do
      before :each do
        attacker_word = Word.create!(value: 'CoMet')
        attacker.ships.create!(word: attacker_word)
      end

      it "returns 200 HTTP status" do
        post "/defenses", params: { word: 'comet', perfect_typing: '1' }
        expect(response).to have_http_status(200)
      end

      it 'broadcasts a failed defense payload' do
        allow(ActionCable.server).to receive(:broadcast)
        post "/defenses", params: { word: 'comet' }
        expect(ActionCable.server).to have_received(:broadcast).with(
          anything,
          {
            code:        'failed_defense',
            player_id:   player.id,
            word:        'comet',
            error_codes: ['wrong_case']
          }
        )
      end
    end

    context 'when word matching ship has already been destroyed' do
      before :each do
        attacker_word = Word.create!(value: 'down')
        attacker.ships.create!(word: attacker_word, state: 'destroyed')
      end

      it "returns 200 HTTP status" do
        post "/defenses", params: { word: 'down', perfect_typing: '1' }
        expect(response).to have_http_status(200)
      end

      it 'broadcasts a failure defense payload' do
        allow(ActionCable.server).to receive(:broadcast)
        post "/defenses", params: { word: 'down', perfect_typing: '1' }

        expect(ActionCable.server).to have_received(:broadcast).with(
          anything,
          {
            code:        'failed_defense',
            player_id:   player.id,
            word:        'down',
            error_codes: ['already_destroyed']
          }
        )
      end
    end

    context 'when word matching ship has already accomplissed its mission' do
      before :each do
        attacker_word = Word.create!(value: 'DONE')
        attacker.ships.create!(word: attacker_word, state: 'mission_accomplished')
      end

      it "returns 200 HTTP status" do
        post "/defenses", params: { word: 'DONE', perfect_typing: '1' }
        expect(response).to have_http_status(200)
      end

      it 'broadcasts a failure defense payload' do
        allow(ActionCable.server).to receive(:broadcast)
        post "/defenses", params: { word: 'DONE', perfect_typing: '1' }

        expect(ActionCable.server).to have_received(:broadcast).with(
          anything,
          {
            code:        'failed_defense',
            player_id:   player.id,
            word:        'DONE',
            error_codes: ['bomb_already_dropped']
          }
        )
      end
    end

    context "when word matches one of attacker's ships" do
      before :each do
        attacker_word = Word.create!(value: 'HacKeR')
        attacker.ships.create!(word: attacker_word)
      end

      it "returns 200 HTTP status" do
        post "/defenses", params: { word: 'HacKeR', perfect_typing: '1' }
        expect(response).to have_http_status(200)
      end

      it 'broadcasts a successful defense payload' do
        allow(ActionCable.server).to receive(:broadcast)
        post "/defenses", params: { word: 'HacKeR', perfect_typing: '1' }
        expect(ActionCable.server).to have_received(:broadcast).with(
          anything,
          {
            code:      'successful_defense',
            player_id: player.id,
            word:      'HacKeR',
            strike: {
              gauge:    6,
              unlocked: nil
            }
          }
        )
      end
    end

    context "when matching word not perfectly typed" do
      before :each do
        attacker_word = Word.create!(value: 'flaw')
        attacker.ships.create!(word: attacker_word)
      end

      it "returns 200 HTTP status" do
        post "/defenses", params: { word: 'flaw', perfect_typing: '0' }
        expect(response).to have_http_status(200)
      end

      it 'broadcasts a successful defense payload' do
        allow(ActionCable.server).to receive(:broadcast)
        post "/defenses", params: { word: 'flaw' }
        expect(ActionCable.server).to have_received(:broadcast).with(
          anything,
          {
            code:      'successful_defense',
            player_id: player.id,
            word:      'flaw',
            strike: {
              gauge:    0,
              unlocked: nil
            }
          }
        )
      end
    end

    context 'when game is finished' do
      before :each do
        attacker_word = Word.create!(value: 'finished')
        attacker.ships.create!(word: attacker_word)
        game.update(state: 'finished')
      end

      it "returns 200 HTTP status" do
        post "/defenses", params: { word: 'finished', perfect_typing: '0' }
        expect(response).to have_http_status(200)
      end

      it 'broadcasts a failed defense payload' do
        allow(ActionCable.server).to receive(:broadcast)
        post "/defenses", params: { word: 'finished' }
        expect(ActionCable.server).to have_received(:broadcast).with(
          anything,
          {
            code:        'failed_defense',
            player_id:   player.id,
            word:        'finished',
            error_codes: ['not_running']
          }
        )
      end
    end
  end
end

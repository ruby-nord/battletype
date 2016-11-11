require "rails_helper"

RSpec.describe "Attacks", type: :request do
  let(:game)            { Game.create!(name: 'Starship Battle', state: 'running') }
  let(:player)          { game.players.create!(nickname: "Rico") }

  before :each do
    allow_any_instance_of(ApplicationController).to receive(:current_player).and_return(player)
  end

  describe "POST create" do
    context 'when no word is provided' do
      it 'returns 422 HTTP status' do
        post "/attacks"
        expect(response).to have_http_status(422)
      end
    end

    context "when provided word is an English word" do
      it "returns 200 HTTP status" do
        allow_words("curry")
        post "/attacks", params: { word: 'curry' }
        expect(response).to have_http_status(200)
      end

      it 'broadcasts a launched ship payload' do
        allow_words("curry")
        allow(ActionCable.server).to receive(:broadcast)
        post "/attacks", params: { word: 'curry' }
        expect(ActionCable.server).to have_received(:broadcast).with(
          anything,
          code: 'successful_attack', player_id: player.id, word: 'curry', launched_ship: { type: 'medium', damage: 2, velocity: 6 }
        )
      end
    end

    context 'when provided word has already been played' do
      before :each do
        game.words.create!(value: 'duplicate')
        allow_words("duplicate")
      end

      it 'returns 200 HTTP status' do
        post "/attacks", params: { word: 'duplicate' }
        expect(response).to have_http_status(200)
      end

      it 'broadcasts an error message' do
        allow(ActionCable.server).to receive(:broadcast)
        post "/attacks", params: { word: 'duplicate' }
        expect(ActionCable.server).to have_received(:broadcast).with(anything, code: 'failed_attack', word: 'duplicate', player_id: player.id, error_codes: ['unique_case_insensitive_word'] )
      end
    end

    context 'when provided word has already been played with a different case' do
      before :each do
        allow_words("battletype")
        game.words.create!(value: 'BattleType')
      end

      it 'returns 422 HTTP status' do
        post "/attacks", params: { word: 'battletype' }
        expect(response).to have_http_status(200)
      end

      it 'broadcasts an error message' do
        allow(ActionCable.server).to receive(:broadcast)
        post "/attacks", params: { word: 'battletype' }
        expect(ActionCable.server).to have_received(:broadcast).with(anything, code: 'failed_attack', player_id: player.id, word: 'battletype', error_codes: ["unique_case_insensitive_word"])
      end
    end

    context 'when game is finished' do
      before :each do
        allow_words("finished")
        game.update(state: 'finished')
      end

      it 'returns 200 HTTP status' do
        post "/attacks", params: { word: 'finished' }
        expect(response).to have_http_status(200)
      end

      it 'broadcasts an error message' do
        allow(ActionCable.server).to receive(:broadcast)
        post "/attacks", params: { word: 'finished' }
        expect(ActionCable.server).to have_received(:broadcast).with(anything, code: 'failed_attack', word: 'finished', player_id: player.id, error_codes: ['not_running'] )
      end
    end
  end
end

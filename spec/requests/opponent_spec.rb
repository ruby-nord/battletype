require "rails_helper"

RSpec.describe "Opponent", type: :request do
  describe 'POST create' do
    let(:game) { Game.create!(name: 'Starship Battle', slug: 'starship-battle', state: 'awaiting_opponent') }

    before :each do
      game.players.create!
    end

    context 'when game is not full' do
      before :each do
        allow(ActionCable.server).to receive(:broadcast)
        post "/games/starship-battle/opponent"
      end

      it { expect(response).to redirect_to("/games/starship-battle") }
      it { expect(Player.count).to eq(2) }
      it { expect(Player.last.game).to eq(game) }
      it { expect(Player.last.life).to eq(10) }

      it 'sets game state to running' do
        expect(game.reload.state).to eq('running')
      end

      it 'broadcasts a player joined payload' do
        expect(ActionCable.server).to have_received(:broadcast).with(
          anything,
          {
            code:       'player_joined',
            player_id:  Player.last.id,
            nickname:   Player.last.nickname
          }
        )
      end
    end

    context 'when game is full' do
      before :each do
        game.running!
        game.players.create!
        post "/games/starship-battle/opponent"
      end

      it { expect(response).to redirect_to("/games/starship-battle") }
      it { expect(Player.count).to eq(2) }
      it { expect(Game.last.state).to eq('running') }

      it 'tells game is full' do
        follow_redirect!
        expect(response.body).to include('already full')
      end
    end

    context 'when game is already finished' do
      before :each do
        game.finished!
        post "/games/starship-battle/opponent"
      end

      it { expect(response).to redirect_to("/games/starship-battle") }
      it { expect(Player.count).to eq(1) }
      it { expect(Game.last.state).to eq('finished') }

      it 'tells game is finished' do
        follow_redirect!
        expect(response.body).to include('Game Finished')
      end
    end

    context "game doesn't exist" do
      before :each do
        post "/games/foo/opponent"
      end

      it { expect(response).to redirect_to(root_path) }
      it { expect(Player.count).to eq(1) }
    end
  end
end

require "rails_helper"

RSpec.describe "Games", type: :request do
  let(:game) { Game.create!(name: 'Starship Battle', slug: 'starship-battle') }

  describe "GET show" do
    context "url is not parametrized" do
      before :each do
        get URI::encode("/games/#{game.name}")
      end

      it { expect(Game.count).to eq(1) }
    end

    context "player is signed in" do
      let(:player) { Player.create! }

      before :each do
        allow_any_instance_of(ApplicationController).to receive(:current_player).and_return(player)
      end

      context "game is full" do
        before { 2.times { Player.create(game: game) } }

        before { get "/games/#{game.to_param}" }

        it { expect(response.body).to include("already full") }
        it { expect(player.reload.game).to_not eq(game) }
      end

      context  "player joined the game and refresh the page" do
        let!(:opponent) { Player.create(game: game) }

        before :each do
          player.update(game: game)

          get "/games/#{game.to_param}"
        end

        it { expect(response.body).to_not include("already full") }
        it { expect(player.reload.game).to eq(game) }
      end

      context "user switch to other game" do
        let(:other_game) { Game.create!(name: 'Other game', slug: 'other-game') }

        before :each do
          player.update(game: game, nickname: "Rico", life: 3)
          get "/games/#{other_game.to_param}"
        end

        it { expect(Player.count).to eq(2) }
        it { expect(Player.last.id).not_to eq(player.id) }
        it { expect(Player.last.nickname).to eq("Rico") }
        it { expect(Player.last.life).to eq(10) }
        it { expect(response).to have_http_status(200) }
        it { expect(response.body).to_not include("already full") }
      end
    end

    context "player is not signed in" do
      context "game is not full" do
        before :each do
          game.update(state: 'awaiting_opponent')
          allow(ActionCable.server).to receive(:broadcast)
          get "/games/#{game.to_param}"
        end

        it { expect(response).to have_http_status(200) }
        it { expect(Player.count).to eq(1) }
        it { expect(response.body).to include(game.name) }
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

      context "game is already full" do
        before { 2.times { Player.create!(game: game) } }

        before { get "/games/#{game.to_param}" }

        it { expect(response).to have_http_status(200) }
        it { expect(Player.count).to eq(2) }
        it { expect(response.body).to include("already full") }
      end
    end

    context "Game doesn't exist" do
      before { get "/games/foo" }

      it { expect(response).to redirect_to(root_path) }
      it { expect(Game.count).to eq(0) }
    end

    context "when game is finished" do
      before :each do
        game.update(state: "finished")
        Player.create!(nickname: "Zim", game: game)
        Player.create!(nickname: "Rico", game: game, won: true)

        get "/games/#{game.to_param}"
      end

      it { expect(response.body).to include("finished") }
    end
  end

  describe "POST create" do
    context "game doesn't exist" do
      before { post "/games", params: {game: {name: "foobar"} } }

      it { expect(Game.count).to eq(1) }
      it { expect(Game.last.name).to eq("foobar") }

      it 'sets state of created game to awaiting_opponent' do
        expect(Game.last.state).to eq('awaiting_opponent')
      end
    end

    context "game already exist" do
      let!(:another_game) { Game.create!(slug: "other") }
      let!(:existing_game) { Game.create!(slug: "foobar") }
      before { post "/games", params: {game: {name: "foobar"} } }

      it { expect(Game.count).to eq(2) }
      it { expect(response).to redirect_to(game_url(existing_game)) }
    end

    context "game name has special characters" do
      before { post "/games", params: {game: {name: "c'est la fête"} } }

      it { expect(Game.last.name).to eq("c'est la fête") }
      it { expect(Game.last.slug).to eq("c-est-la-fete") }
    end
  end
end

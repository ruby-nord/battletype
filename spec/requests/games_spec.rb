require "rails_helper"

RSpec.describe "Games", type: :request do
  let(:game) { Game.create!(name: 'Starship Battle', slug: 'starship-battle') }

  describe "GET show" do
    context "player is signed in" do
      let(:player) { Player.create!(life: 10) }

      before :each do
        allow_any_instance_of(ApplicationController).to receive(:current_player).and_return(player)
      end

      context "url is not parameterized" do
        before :each do
          game.update(state: 'awaiting_opponent')
          allow_any_instance_of(ApplicationController).to receive(:current_player).and_return(player)
          get URI::encode("/games/#{game.name}")
        end

        it { expect(Game.count).to eq(1) }
      end

      context "game is full" do
        before :each do
          game.update(state: 'running')
          2.times { Player.create(game: game) }
          get "/games/#{game.to_param}"
        end


        it { expect(response.body).to include("already full") }
        it { expect(player.reload.game).to_not eq(game) }
      end

      context "player joined the game and refresh the page" do
        let!(:opponent) { Player.create(game: game, life: 10) }

        before :each do
          game.update(state: 'running')
          player.update(game: game)

          allow_any_instance_of(ApplicationController).to receive(:current_player).and_return(player)
          get "/games/#{game.to_param}"
        end

        it { expect(response.body).to_not include("already full") }
        it { expect(player.reload.game).to eq(game) }
      end

      context "user switch to other game" do
        let(:other_game) { Game.create!(name: 'Other game', slug: 'other-game') }

        before :each do
          other_game.update(state: 'awaiting_opponent')
          player.update(game: game, nickname: "Rico", life: 3)
          get "/games/#{other_game.to_param}"
        end

        it { expect(response).to have_http_status(200) }
        it { expect(response.body).to include("Join Game") }

        it { expect(Player.last.id).to eq(player.id) }
        it { expect(Player.last.nickname).to eq("Rico") }

        it 'does not create a new player' do
          expect(Player.count).to eq(1)
        end

        it "does not update player's life" do
          expect(Player.last.life).to eq(3)
        end

        it 'does not change game of current player' do
          expect(Player.last.game).to eq(game)
        end
      end
    end

    context "player is not signed in" do
      context "game is not full" do
        before :each do
          game.update(state: 'awaiting_opponent')
          get "/games/#{game.to_param}"
        end

        it { expect(response).to have_http_status(200) }
        it { expect(response.body).to include(game.name) }
        it { expect(response.body).to include("Join Game") }
        it { expect(Player.count).to eq(0) }
        it { expect(game.reload.state).to eq('awaiting_opponent') }
      end

      context "game is already full" do
        before :each do
          game.update(state: 'running')
          2.times { Player.create!(game: game) }
          get "/games/#{game.to_param}"
        end

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

    context "when players have already lost part of their life" do
      let(:rico) { Player.create!(nickname: "Rico") }
      let(:zim)  { Player.create!(nickname: "Zim") }

      before :each do
        game.update(state: "running")
        rico.update(game: game, life: 8)
        zim.update(game: game, life: 3)

        allow_any_instance_of(ApplicationController).to receive(:current_player).and_return(rico)
      end

      it "has 8 bars of life for the current player" do
        get "/games/#{game.to_param}"
        expect(response.body).to have_css('#life_player .life_bar', count: 8)
      end

      it "has 3 bars of life for the opponent player" do
        get "/games/#{game.to_param}"
        expect(response.body).to have_css('#life_opponent .life_bar', count: 3)
        # HERE
      end
    end

    context "when game is finished" do
      let(:rico)  { Player.create!(nickname: "Rico") }
      let(:zim)   { Player.create!(nickname: "Zim") }

      before :each do
        game.update(state: "finished")

        rico.update!(game: game, won: true)
        zim.update!(game: game, won: false)
      end

      it 'tells that the game is finished' do
        get "/games/#{game.to_param}"
        expect(response.body).to include("finished")
      end

      context 'when the signed-in player won the game' do
        before :each do
          allow_any_instance_of(ApplicationController).to receive(:current_player).and_return(rico)
        end

        it 'tells the user that he won' do
          get "/games/#{game.to_param}"
          expect(response.body).to include("WON")
        end
      end

      context 'when the signed-in player lost the game' do
        before :each do
          allow_any_instance_of(ApplicationController).to receive(:current_player).and_return(zim)
        end

        it 'tells the user that he lost' do
          get "/games/#{game.to_param}"
          expect(response.body).to include("LOSE")
        end
      end
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

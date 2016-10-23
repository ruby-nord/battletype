require "rails_helper"

RSpec.describe "Games", type: :request do
  let(:game)            { Game.create!(name: 'Starship Battle', slug: 'starship-battle') }

  describe "GET show" do
    context "player is signed in" do
      let(:player) { Player.create! }

      before :each do
        allow_any_instance_of(ApplicationController).to receive(:current_player).and_return(player)
      end

      context "game is full" do
        before { 2.times { Player.create(game: game) } }

        before { get "/games/#{game.to_param}" }

        it { expect(response.body).to include("This game is already full, please start a new game") }
        it { expect(player.reload.game).to_not eq(game) }
      end

      context  "user refresh page" do
        let!(:opponent) { Player.create(game: game) }
        before { player.update(game: game) }

        before { get "/games/#{game.to_param}" }

        it { expect(response.body).to_not include("This game is already full, please start a new game") }
        it { expect(player.reload.game).to eq(game) }
      end

      context "user changes game" do
        before { player.update(game: game, nickname: "Rico") }

        before { get "/games/new_game" }

        it { expect(Player.count).to eq(2) }
        it { expect(Player.last.nickname).to eq("Rico") }
        it { expect(response).to have_http_status(200) }
        it { expect(response.body).to_not include("This game is already full, please start a new game") }
      end
    end

    context "player is not signed in" do
      context "game is not full" do
        before { get "/games/#{game.to_param}" }

        it { expect(response).to have_http_status(200) }
        it { expect(Player.count).to eq(1) }
        it { expect(response.body).to include(game.name) }
        it { expect(Player.last.game).to eq(game) }
      end

      context "game is already full" do
        before { 2.times { Player.create!(game: game) } }

        before { get "/games/#{game.to_param}" }

        it { expect(response).to have_http_status(200) }
        it { expect(Player.count).to eq(2) }
        it { expect(response.body).to include("This game is already full, please start a new game") }
      end
    end

    context "Game doesn't exist" do
      before { get "/games/foo" }

      it { expect(response).to have_http_status(200) }
      it { expect(Game.count).to eq(1) }
      it { expect(Game.last.name).to eq("foo") }
    end
  end

  describe "POST create" do
    context "game doesn't exist" do
      before { post "/games", params: {game: {name: "foobar"} } }

      it { expect(Game.count).to eq(1) }
      it { expect(Game.last.name).to eq("foobar") }
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
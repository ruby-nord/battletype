require "rails_helper"

RSpec.describe "Games", type: :request do
  let(:game)            { Game.create!(name: 'Starship Battle') }

  describe "GET show" do
    context "player is signed in" do
      let(:player) { Player.create! }
      before :each do
        allow_any_instance_of(ApplicationController).to receive(:current_player).and_return(player)
      end

      before { get "/games/#{game.to_param}" }

      it { expect(response).to have_http_status(200) }
      it { expect(Player.count).to eq(1) }
      it { expect(response.body).to include(game.name) }
    end

    context "player is not signed in" do
      before { get "/games/#{game.to_param}" }

      it { expect(response).to have_http_status(200) }
      it { expect(Player.count).to eq(1) }
      it { expect(response.body).to include(game.name) }
    end

    context "game is already full" do
      before do
        Player.create!(game: game)
        Player.create!(game: game)
      end

      before { get "/games/#{game.to_param}" }

      it { expect(response).to have_http_status(200) }
      it { expect(Player.count).to eq(2) }
      it { expect(response.body).to include("This game is already full, please start a new game") }
    end

    context "Game doesn't exist" do
      before { get "/games/foo" }

      it { expect(response).to have_http_status(200) }
      it { expect(Game.count).to eq(1) }
      it { expect(Game.last.name).to eq("foo") }
    end
  end
end
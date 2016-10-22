require "rails_helper"

RSpec.describe "Games", type: :request do
  let(:game)            { Game.create!(name: 'Starship Battle') }

  describe "GET show" do
    context "playser is signed in" do
      before { get :show, params: {game_id: game.to_param} }
      it { expect(response).to have_http_status(200) }
    end
  end
end
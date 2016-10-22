require "rails_helper"

RSpec.describe "Attacks", type: :request do
  let(:game)            { Game.create!(name: 'Starship Battle') }
  let(:player)          { game.players.create! }

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
        post "/attacks", params: { word: 'curry' }
        expect(response).to have_http_status(200)
      end
    end

  # NEXT:
  # - mot du dico anglais
  # - mot pas du dico anglais
  # - meme mot case differente
  # - meme mot
  # - meme mot pluriel
  # - meme mot singulier
  end
end

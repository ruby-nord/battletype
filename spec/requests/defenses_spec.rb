require "rails_helper"

RSpec.describe "Defenses", type: :request do
  let(:game)      { Game.create!(name: 'Starship Battle') }
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
      it "returns 422 HTTP status" do
        post "/defenses", params: { word: 'unknown', perfect_typing: '1' }
        expect(response).to have_http_status(422)
      end
    end

    context "when word matches player's own ship" do
      before :each do
        own_word = Word.create!(value: 'own')
        player.ships.create!(word: own_word)
      end

      it "returns 422 HTTP status" do
        post "/defenses", params: { word: 'own', perfect_typing: '1' }
        expect(response).to have_http_status(422)
      end
    end

    context "when word matches one of attacker's ships with wrong case" do
      before :each do
        attacker_word = Word.create!(value: 'CoMet')
        attacker.ships.create!(word: attacker_word)
      end

      it "returns 422 HTTP status" do
        post "/defenses", params: { word: 'comet', perfect_typing: '1' }
        expect(response).to have_http_status(422)
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
    end

    context "when matching word not perfectly typed" do
      before :each do
        attacker_word = Word.create!(value: 'perfect')
        attacker.ships.create!(word: attacker_word)
      end

      it "returns 200 HTTP status" do
        post "/defenses", params: { word: 'perfect', perfect_typing: '0' }
        expect(response).to have_http_status(200)
      end
    end
  end
end

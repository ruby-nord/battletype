require "rails_helper"

RSpec.describe "Players", type: :request do
  let(:player) { Player.create!(nickname: "Rico") }

  describe "PUT update" do
    context 'update current_player' do
      before :each do
        allow_any_instance_of(ApplicationController).to receive(:current_player).and_return(player)
      end

      it "returns 200 HTTP status" do
        put "/players/#{player.id}", params: { player: { nickname: "Zim" }}
        expect(response).to have_http_status(200)
      end

      it "updates player nickname" do
        put "/players/#{player.id}", params: { player: { nickname: "Zim" }}
        expect(player.reload.nickname).to eq("Zim")
      end

      it 'broadcasts a player nickname updated payload' do
        allow(ActionCable.server).to receive(:broadcast)
        put "/players/#{player.id}", params: { player: { nickname: "Zim" }}
        expect(ActionCable.server).to have_received(:broadcast).with(
          anything,
          code: 'player_nickname_changed', player_id: player.id, nickname: 'Zim'
        )
      end
    end

    context 'update another player' do
      let(:other_player) { Player.create!(nickname: "Carmen") }

      before :each do
        allow_any_instance_of(ApplicationController).to receive(:current_player).and_return(other_player)
        put "/players/#{player.id}", params: { player: { nickname: "Ace" }}
      end

      it { expect(response).to have_http_status(401) }
      it { expect(player.reload.nickname).to eq("Rico") }
    end
  end
end

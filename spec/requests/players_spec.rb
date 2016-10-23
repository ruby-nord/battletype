require "rails_helper"

RSpec.describe "Players", type: :request do
  let(:player)          { Player.create!(nickname: "Rico") }

  describe "PUT update" do
    context 'update current_player' do
      before :each do
        allow_any_instance_of(ApplicationController).to receive(:current_player).and_return(player)
      end

      before { put "/players/#{player.id}", params: {player: {nickname: "Zim"}} }
      it { expect(response).to have_http_status(200) }
      it { expect(player.reload.nickname).to eq("Zim") }
    end
  end

  context 'update another player' do
    let(:other_player) { Player.create!(nickname: "Carmen") }
    before :each do
      allow_any_instance_of(ApplicationController).to receive(:current_player).and_return(other_player)
    end

    before { put "/players/#{player.id}", params: {player: {nickname: "Ace"}} }
    it { expect(response).to have_http_status(401) }
    it { expect(player.reload.nickname).to eq("Rico") }
  end
end
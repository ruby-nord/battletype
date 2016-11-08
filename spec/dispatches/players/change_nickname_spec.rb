require "rails_helper"

RSpec.describe "Players::ChangeNickname", type: :dispatch do
  subject(:dispatch)  { Players::ChangeNickname }
  let(:game)          { Game.create! }
  let(:player)        { Player.create!(game: game, nickname: "Rico") }

  describe ".call" do
    it 'updates player nickname' do
      expect { dispatch.call(player: player, nickname: "Zim") }.to change { player.nickname }.from("Rico").to("Zim")
    end

    it 'returns a payload' do
      expect(dispatch.call(player: player, nickname: "Zim")).to be_instance_of(Hash)
    end

    it "returns payload with the new nickname of the player" do
      expect(dispatch.call(player: player, nickname: "Zim")).to include(code: 'player_nickname_changed', player_id: player.id, nickname: "Zim")
    end
  end
end

require "rails_helper"

RSpec.describe Player, type: :model do
  let(:game) { Game.new }
  subject(:player) { Player.new game: game }

  it { is_expected.to belong_to(:game) }
  it { is_expected.to have_many(:ships) }

  describe "#plays_in?" do
    it "is true if a player is part of the given game", :aggregate_failures do
      expect(player.plays_in?(game)).to eql(true)
      expect(player.plays_in?(Game.new)).to eql(false)
    end
  end
end

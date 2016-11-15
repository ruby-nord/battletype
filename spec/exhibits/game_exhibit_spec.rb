require "rails_helper"

RSpec.describe "GameExhibit" do
  let(:game) { Game.new }
  let(:player) { Player.new }
  subject(:game_exhibit) { GameExhibit.new(game, player) }
  
  describe "#to_partial_path" do
    subject { game_exhibit.to_partial_path }
    
    context "when the current player is actually playing the game" do
      before { player.game = game }
      
      context "if the game is waiting for an opponent" do
        before { allow(game).to receive(:state).and_return("awaiting_opponent") }
        it { is_expected.to eql("games/game") }
      end
      
      context "if the game is running" do
        before { allow(game).to receive(:state).and_return("running") }
        it { is_expected.to eql("games/game") }
      end
      
      context "if the game is over" do
        before { allow(game).to receive(:state).and_return("finished") }
        it { is_expected.to eql("games/finished_game") }
      end
    end
    
    context "when the current player is not part of the game" do
      before { player.game = Game.new }
      
      context "if the game is waiting for an opponent" do
        before { allow(game).to receive(:state).and_return("awaiting_opponent") }
        it { is_expected.to eql("games/awaiting_opponent_game") }
      end
      
      context "if the game is running" do
        before { allow(game).to receive(:state).and_return("running") }
        it { is_expected.to eql("games/full_game") }
      end
      
      context "if the game is over" do
        before { allow(game).to receive(:state).and_return("finished") }
        it { is_expected.to eql("games/finished_game") }
      end
    end
  end
end

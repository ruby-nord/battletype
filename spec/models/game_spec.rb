require "rails_helper"

RSpec.describe "Game", type: :model do
  subject(:game) { Game.new }

  it { is_expected.to have_one(:loser).class_name(Player).conditions(won: false) }
  it { is_expected.to have_one(:winner).class_name(Player).conditions(won: true) }

  it { is_expected.to have_many(:players) }
  it { is_expected.to have_many(:ships) }
  it { is_expected.to have_many(:words) }
  
  describe "#awaiting_opponent?" do
    it "returns true if the game is in the AWAITING_OPPONENT state" do
      expect(Game.new(state: Game::AWAITING_OPPONENT).awaiting_opponent?).to eql(true)
      expect(Game.new(state: Game::RUNNING).awaiting_opponent?).to eql(false)
      expect(Game.new(state: Game::FINISHED).awaiting_opponent?).to eql(false)
    end
  end
  
  describe "#awaiting_opponent!" do
    it "updates the game's state" do
      game = Game.new(state: nil)
      expect { game.awaiting_opponent! }.to change { game.state }.from(nil).to(Game::AWAITING_OPPONENT)
    end
  end
  
  describe "#running?" do
    it "returns true if the game is in the RUNNING state" do
      expect(Game.new(state: Game::AWAITING_OPPONENT).running?).to eql(false)
      expect(Game.new(state: Game::RUNNING).running?).to eql(true)
      expect(Game.new(state: Game::FINISHED).running?).to eql(false)
    end
  end
  
  describe "#running!" do
    it "updates the game's state" do
      game = Game.new(state: nil)
      expect { game.running! }.to change { game.state }.from(nil).to(Game::RUNNING)
    end
  end
  
  describe "#finished?" do
    it "returns true if the game is in the FINISHED state" do
      expect(Game.new(state: Game::AWAITING_OPPONENT).finished?).to eql(false)
      expect(Game.new(state: Game::RUNNING).finished?).to eql(false)
      expect(Game.new(state: Game::FINISHED).finished?).to eql(true)
    end
  end
  
  describe "#finished!" do
    it "updates the game's state" do
      game = Game.new(state: nil)
      expect { game.finished! }.to change { game.state }.from(nil).to(Game::FINISHED)
    end
  end
  
  describe '#full?' do
    before :each do
      game.save!
    end

    context 'when there is no player' do
      it 'returns false' do
        expect(game.full?).to eq(false)
      end
    end

    context 'when there is one player' do
      before :each do
        game.players.create!
      end

      it 'returns false' do
        expect(game.full?).to eq(false)
      end
    end

    context 'when there are two players' do
      before :each do
        2.times { game.players.create! }
      end

      it 'returns true' do
        expect(game.full?).to eq(true)
      end
    end
  end
end

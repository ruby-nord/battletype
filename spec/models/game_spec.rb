require "rails_helper"

RSpec.describe "Game", type: :model do
  subject(:game) { Game.new }

  it { is_expected.to have_one(:loser).class_name(Player).conditions(won: false) }
  it { is_expected.to have_one(:winner).class_name(Player).conditions(won: true) }

  it { is_expected.to have_many(:players) }
  it { is_expected.to have_many(:ships) }
  it { is_expected.to have_many(:words) }

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

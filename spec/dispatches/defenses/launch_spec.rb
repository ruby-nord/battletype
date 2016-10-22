require "rails_helper"

RSpec.describe "Defenses::Launch", type: :dispatch do
  subject(:dispatch)  { Defenses::Launch }

  let(:game)          { Game.create! }
  let(:attacker)      { Player.create!(game: game) }
  let(:attacker_ship) { attacker.ships.last }
  let(:attacker_word) { Word.create!(value: 'attacker', game: game) }
  let(:player)        { Player.create!(game: game) }

  before :each do
    attacker.ships.create!(word: attacker_word, state: 'engaged')
  end

  describe ".call" do
    context "when defense is valid" do
      let(:word) { 'attacker' }

      it "marks attacker's ship as destroyed" do
        dispatch.call(player, word)
        expect(attacker_ship.state).to eq('destroyed')
      end

      it 'returns a Defense object' do
        expect(dispatch.call(player, word)).to be_instance_of(Defense)
      end
    end

    context "when defense is not valid" do
      let(:word) { 'unknown' }

      it "does not mars any attacker's ship as destroyed" do
        dispatch.call(player, word)
        expect(attacker_ship.state).to eq('engaged')
      end

      it 'returns a Defense object' do
        expect(dispatch.call(player, word)).to be_instance_of(Defense)
      end
    end
  end
end

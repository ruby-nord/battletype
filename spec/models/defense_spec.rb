require "rails_helper"

RSpec.describe "Defense", type: :model do
  subject(:defense)   { Defense.new(player, word) }

  let(:game)          { Game.create! }
  let(:attacker)      { Player.create!(game: game) }
  let(:attacker_word) { Word.create!(value: 'HaCkeR', game: game) }
  let(:player)        { Player.create!(game: game) }

  before :each do
    attacker.ships.create!(word: attacker_word, state: 'engaged')
  end

  describe '#valid?' do
    context "when word does not match any attacker ship" do
      let(:word) { 'unknown' }

      it 'returns false' do
        expect(defense.valid?).to eq(false)
      end
    end

    context "when word matches player's own ship" do
      let(:word) { 'own' }

      it 'returns false' do
        expect(defense.valid?).to eq(false)
      end
    end

    context "when word matches one of attacker's ships with wrong case" do
      let(:word) { 'hacker' }

      it 'returns false' do
        expect(defense.valid?).to eq(false)
      end
    end

    context "when word matches one of attacker's ships" do
      let(:word) { 'HaCkeR' }

      it 'returns true' do
        expect(defense.valid?).to eq(true)
      end
    end
  end
end

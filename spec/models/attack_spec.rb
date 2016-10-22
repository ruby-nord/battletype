require "rails_helper"

RSpec.describe "Attack", type: :model do
  subject(:attack)  { Attack.new(game, word) }
  let(:game)        { Game.create! }
  let(:word)        { 'attack' }
  before { allow_words("attack") }

  describe '#valid?' do
    context 'when word has never been played' do
      it 'returns true' do
        expect(attack.valid?).to eq(true)
      end
    end

    context 'when word has already been played' do
      before :each do
        Word.create!(value: word, game: game)
      end

      it 'returns false' do
        expect(attack.valid?).to eq(false)
      end
    end

    context 'when word has already been played with different case' do
      before :each do
        Word.create!(value: 'AtTaCk', game: game)
      end

      it 'returns false' do
        expect(attack.valid?).to eq(false)
      end
    end

    describe "Word length verification" do
      before { allow_words(["a", "aa", "aaa"]) }
      it { expect(Attack.new(game, "a").valid?).to be false }
      it { expect(Attack.new(game, "aa").valid?).to be true }
      it { expect(Attack.new(game, "aaa").valid?).to be true }
    end

    describe "Word should exist in dictionary" do
      before { allow_words("animal") }
      it { expect(Attack.new(game, "animal").valid?).to be true }
      it { expect(Attack.new(game, "AniMal").valid?).to be true }
      it { expect(Attack.new(game, "animal12").valid?).to be false }
    end
  end
end

require "rails_helper"

RSpec.describe "Attack", type: :model do
  subject(:attack)  { Attack.new(game: game, word: word, player: player) }
  let(:game)        { Game.create!(state: 'running') }
  let(:word)        { 'attack' }
  let(:player)      { Player.new }

  before { allow_words("attack") }

  describe '.reward_for' do
    describe 'word between 0 and 1 letters' do
      it 'returns nil for an empty string ' do
        expect(Attack.reward_for(word: '')).to eq(nil)
      end

      it 'returns nil for a word with 1 letter' do
        expect(Attack.reward_for(word: 'a')).to eq(nil)
      end
    end

    describe 'word between 2 and 3 letters' do
      it 'returns SMALL ship for a word with 2 letters' do
        expect(Attack.reward_for(word: 'he')).to eq(Ship::SMALL)
      end

      it 'returns SMALL ship for a word with 3 letters' do
        expect(Attack.reward_for(word: 'sun')).to eq(Ship::SMALL)
      end
    end

    describe 'word between 4 and 6 letters' do
      it 'returns MEDIUM ship for a word with 4 letters' do
        expect(Attack.reward_for(word: 'ship')).to eq(Ship::MEDIUM)
      end

      it 'returns MEDIUM ship for a word with 5 letters' do
        expect(Attack.reward_for(word: 'fleet')).to eq(Ship::MEDIUM)
      end

      it 'returns MEDIUM ship for a word with 6 letters' do
        expect(Attack.reward_for(word: 'rocket')).to eq(Ship::MEDIUM)
      end
    end

    describe 'word with at least 7 letters' do
      it 'returns LARGE ship for a word with 7 letters' do
        expect(Attack.reward_for(word: 'missile')).to eq(Ship::LARGE)
      end

      it 'returns LARGE ship for a word with 8 letters' do
        expect(Attack.reward_for(word: 'starship')).to eq(Ship::LARGE)
      end
    end
  end

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
      let(:word) { 'decontamination' }

      before :each do
        Word.create!(value: 'DeConTaminaTION', game: game)
      end

      it 'returns false' do
        expect(attack.valid?).to eq(false)
      end
    end

    describe "Word length verification" do
      before { allow_words(["a", "aa", "aaa"]) }

      it { expect(Attack.new(game: game, word: "a", player: player).valid?).to be false }
      it { expect(Attack.new(game: game, word: "aa", player: player).valid?).to be true }
      it { expect(Attack.new(game: game, word: "aaa", player: player).valid?).to be true }
    end

    describe "Word should exist in dictionary" do
      before { allow_words("animal") }

      it { expect(Attack.new(game: game, word: "animal", player: player).valid?).to be true }
      it { expect(Attack.new(game: game, word: "AniMal", player: player).valid?).to be true }
      it { expect(Attack.new(game: game, word: "animal12", player: player).valid?).to be false }
    end

    context 'when game is finished' do
      before :each do
        allow_words("finished")
        game.update(state: 'finished')
      end

      it 'returns false' do
        expect(attack.valid?).to eq(false)
      end
    end
  end
end

require "rails_helper"

RSpec.describe "Attacks::Launch", type: :dispatch do
  subject(:dispatch)  { Attacks::Launch }
  let(:game)          { Game.create! }
  let(:player)        { Player.create!(game: game) }

  describe "POST create" do
    context 'when word is valid' do
      let(:word) { 'curry' }
      before { allow_words("curry") }

      it 'saves the Word' do
        expect { dispatch.call(player, word) }.to change { Word.where(value: word, game: game).count }.from(0).to(1)
      end

      it 'returns an Attack object' do
        expect(dispatch.call(player, word)).to be_instance_of(Attack)
      end
    end

    context 'when word is not valid' do
      let(:word) { 'duplicate' }

      before :each do
        Word.create!(game: game, value: word)
      end

      it 'does not save the word' do
        dispatch.call(player, word)
        expect(Word.where(value: word, game: game).count).to eq(1)
      end

      it 'returns an Attack object' do
        expect(dispatch.call(player, word)).to be_instance_of(Attack)
      end
    end
  end
end


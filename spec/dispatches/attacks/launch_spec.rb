require "rails_helper"

RSpec.describe "Attacks::Launch", type: :dispatch do
  subject(:dispatch)  { Attacks::Launch }
  let(:game)          { Game.create! }
  let(:player)        { Player.create!(game: game) }

  describe ".call" do
    context 'when word is valid' do
      let(:word) { 'curry' }
      before { allow_words("curry") }

      it 'saves the Word' do
        expect { dispatch.call(player, word) }.to change { Word.where(value: word, game: game).count }.from(0).to(1)
      end

      it 'creates a ship' do
        expect { dispatch.call(player, word) }.to change { Ship.where(player: player).count }.from(0).to(1)
      end

      it 'returns an Attack object' do
        expect(dispatch.call(player, word)).to be_instance_of(Attack)
      end

      describe 'created ship' do
        subject(:created_ship) do
          dispatch.call(player, word)
          Ship.last
        end

        let(:word) { 'rocket' }

        it 'has a damage' do
          expect(created_ship.damage).to eq(Ship::MEDIUM[:damage])
        end

        it 'has a velocity' do
          expect(created_ship.velocity).to eq(Ship::MEDIUM[:velocity])
        end

        it 'has a state' do
          expect(created_ship.state).to eq('engaged')
        end

        it 'is linked to the player' do
          expect(created_ship.player).to eq(player)
        end

        it 'is linked to the saved word' do
          expect(created_ship.word).to eq(Word.last)
        end
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

      it 'does not create a ship' do
        dispatch.call(player, word)
        expect(Ship.where(player: player).count).to eq(0)
      end

      it 'returns an Attack object' do
        expect(dispatch.call(player, word)).to be_instance_of(Attack)
      end
    end
  end
end


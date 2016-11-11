require "rails_helper"

RSpec.describe "Attacks::Launch", type: :dispatch do
  subject(:dispatch)  { Attacks::Launch }
  let(:game)          { Game.create!(state: 'running') }
  let(:player)        { Player.create!(game: game, nickname: "Rico") }

  describe ".call" do
    context 'when word is valid' do
      let(:word) { 'curry' }

      before :each do
        allow_words(word)
      end

      it 'saves the Word' do
        expect { dispatch.call(player: player, word: word) }.to change { Word.where(value: word, game: game).count }.from(0).to(1)
      end

      it 'creates a ship' do
        expect { dispatch.call(player: player, word: word) }.to change { Ship.where(player: player).count }.from(0).to(1)
      end

      it 'returns a payload' do
        expect(dispatch.call(player: player, word: word)).to be_instance_of(Hash)
      end

      it "returns payload with the newly launched ship and the attacker's id" do
        expect(dispatch.call(player: player, word: word)).to include(code: 'successful_attack', word: 'curry', launched_ship: { damage: 2, velocity: 6, type: "medium" }, player_id: player.id)
      end

      describe 'created ship' do
        subject(:created_ship) do
          dispatch.call(player: player, word: word)
          Ship.last
        end

        let(:word) { 'rocket' }

        it 'has a damage' do
          expect(created_ship.damage).to eq(Ship::MEDIUM[:damage])
        end

        it 'has a velocity' do
          expect(created_ship.velocity).to eq(Ship::MEDIUM[:velocity])
        end

        it 'has a ship_type' do
          expect(created_ship.ship_type).to eq("medium")
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
        allow_words(word)
        Word.create!(game: game, value: word)
      end

      it 'does not save the word' do
        dispatch.call(player: player, word: word)
        expect(Word.where(value: word, game: game).count).to eq(1)
      end

      it 'does not create a ship' do
        dispatch.call(player: player, word: word)
        expect(Ship.where(player: player).count).to eq(0)
      end

      it 'returns a payload' do
        expect(dispatch.call(player: player, word: word)).to be_instance_of(Hash)
      end

      it "returns a payload with the invalid word and the attacker's id" do
        expect(dispatch.call(player: player, word: word)).to include(code: 'failed_attack', word: "duplicate", player_id: player.id, error_codes: ["unique_case_insensitive_word"])
      end
    end
  end
end

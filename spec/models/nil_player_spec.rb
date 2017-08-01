require 'rails_helper'

describe NilPlayer, type: :model do
  subject(:nil_player) { NilPlayer.new }

  describe '#id' do
    it 'has no id' do
      expect(nil_player.id).to eq(nil)
    end
  end

  describe '#life' do
    it 'has maximum life level' do
      expect(nil_player.life).to eq(10)
    end
  end

  describe '#nickname' do
    it 'has empty nickname' do
      expect(nil_player.nickname).to eq('')
    end
  end
end

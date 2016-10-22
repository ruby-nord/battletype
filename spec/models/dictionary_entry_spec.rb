require 'rails_helper'

describe DictionaryEntry, type: :model do
  describe 'validations' do
    it { should validate_presence_of :word }
  end
end
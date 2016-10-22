require 'rails_helper'

describe DictionaryEntry do
  describe 'validations' do
    it { should validate_presence_of :word }
  end
end
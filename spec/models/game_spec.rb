require "rails_helper"

RSpec.describe "Game", type: :model do
  subject(:game) { Game.new }

  it { is_expected.to have_one(:loser).class_name(Player).conditions(won: false) }
  it { is_expected.to have_one(:winner).class_name(Player).conditions(won: true) }
end

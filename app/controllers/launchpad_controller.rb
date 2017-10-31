class LaunchpadController < ApplicationController
  def show
    @host = ENV.fetch('HOST')
    @game = Game.new

    @random_names = 10.times.map { "#{Haikunator.haikunate(0)}^#{(500 + rand(500)).to_s}" }
  end
end

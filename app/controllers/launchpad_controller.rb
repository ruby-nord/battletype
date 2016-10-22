class LaunchpadController < ApplicationController
  def show
    @game = Game.new
  end
end

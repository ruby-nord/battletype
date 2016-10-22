module Games
  class Create# < Struct.new(name)
    def self.call(name)
      self.new(name).call
    end

    def initialize(name)
      @name = name
    end

    def call
      Game.create!(name: name, slug: name.parameterize)
    end

    private
    attr_reader :name
  end
end
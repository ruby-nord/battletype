module Games
  class Create < Struct.new(:name)
    def call
      Game.create!(name: name, slug: name.parameterize)
    end
  end
end
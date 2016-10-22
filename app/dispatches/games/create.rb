module Games
  class Create < Struct.new(:name)
    def call
      existing_game || new_game
    end

    private

    def existing_game
      Game.where(slug: slug).first
    end

    def new_game
      Game.create!(name: name, slug: slug)
    end

    def slug
      name.parameterize
    end
  end
end
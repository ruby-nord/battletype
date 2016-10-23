## Cleanup

puts 'Cleaning database...'
Game.destroy_all

## Game - Batman VS Superman

puts 'Game: Batman VS Superman...'
game = Game.create!(
  name:             "Batman VS Superman",
  slug:             "Batman VS Superman".parameterize,
  state:            "running"
)

batman = Player.create!(
  nickname:         "Batman",
  life:             10,
  strike_gauge:     0,
  unlocked_strike:  nil,
  human:            true,
  creator:          true,
  won:              false,
  game:             game
)

superman = Player.create!(
  nickname:         "Superman",
  life:             10,
  strike_gauge:     0,
  unlocked_strike:  nil,
  human:            true,
  creator:          false,
  won:              false,
  game:             game
)

### Batman Ships

batman.ships.create!(
  ship_type:  'small',
  damage:     1,
  velocity:   4,
  state:      'engaged',
  word:       Word.new(value: 'lex', game: game)
)

batman.ships.create!(
  ship_type:  'large',
  damage:     4,
  velocity:   12,
  state:      'engaged',
  word:       Word.new(value: 'kryptonite', game: game)
)

### Superman Ships

superman.ships.create!(
  ship_type:  'medium',
  damage:     2,
  velocity:   6,
  state:      'engaged',
  word:       Word.new(value: 'joker', game: game)
)

puts 'Finished!'

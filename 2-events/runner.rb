require_relative 'lib/lotr'

Lotr.start
id = Lotr.add_character('Bilbo', 90)

Lotr.remove_character(id)
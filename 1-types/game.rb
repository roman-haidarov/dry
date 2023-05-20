require 'dry-struct'
require 'dry-types'
require 'time'

module Types
  include Dry.Types()

  Age = Integer.constrained(gteq: 0)
  ItemId = String.constrained(format: /\Aid-\d{2,5}\z/i)
end

class Character < Dry::Struct
  attribute :name, Types::Strict::String
  attribute :age, Types::Age
  attribute :height, Types::Coercible::Float
end

bilbo = Character.new(name: 'Bilbo', age: 90, height: 120.2)
frodo = Character.new(name: 'Frodo', age: 20, height: '122.5')

puts bilbo.inspect
puts bilbo.name
puts frodo.inspect

char_hash = Types::Hash.schema(
  name: Types::Strict::String,
  age: Types::Strict::Integer
    .default(18)
    .constructor { |v| v.nil? ? Dry::Types::Undefined : v }
).strict.with_key_transform(&:to_sym)

puts char_hash[name: 'Bilbo', 'age' => 91].inspect


class Item < Dry::Struct
  attribute :owner, Character
  attribute :description, Types::String.fallback('[EMPTY]'.freeze)
  attribute :inscription, Types::Strict::String.optional
  attribute :price, Types::Coercible::Float
  attribute :found_at, Types::JSON::Time.default { Time.now.utc }
  attribute :locked, Types::Params::Bool
  attribute :weight, Types::Strict::String | Types::Strict::Integer
  attribute :id, Types::ItemId
  attribute :quality, Types::Symbol.default(:common).enum(:common, :uncommon, :rare, :unique)
  attribute :state, Types::String.enum('good' => 0, 'damaged' => 1, 'broken' => 2)
  attribute :prev_owner?, Types::Hash.map(Types::Coercible::String, Types::Integer)
  attribute :dmg?, Types::Instance(Range)
  attribute :tags?, Types::Array.of(Types::Coercible::String)
end

fial = Item.new(
  owner: frodo,
  description: 'burn light',
  inscription: 'Let the light shine!',
  price: '10000.500',
  found_at: "325-11-26 10:00:00",
  locked: true,
  weight: 150,
  id: 'id-123',
  state: 1,
  prev_owner: { 'Galadriel' => 324 },
  dmg: (100..150),
  tags: %i[flashlight elfian magical]
)

ring = Item.new(
  owner: bilbo,
  description: 666,
  inscription: nil,
  price: 1_000_000_000.500,
  locked: '0',
  weight: '20',
  id: 'id-55',
  quality: :unique,
  state: 2,
  prev_owner: { :Sauron => 300, Golum: 301 },
  tags: %w[inevitability eye]
)

puts fial.inspect
puts ring.inspect
puts '=' * 50
puts fial.owner.name.inspect
puts ring.owner.name.inspect

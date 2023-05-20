# frozen_string_literal: true

require 'dry-struct'

module Lotr
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
end
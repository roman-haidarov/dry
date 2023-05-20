# frozen_string_literal: true

require 'dry-struct'

module Lotr
  module Types
    include Dry.Types()

    Age = Integer.constrained(gteq: 0)
    ItemId = String.constrained(format: /\Aid-\d{2,5}\z/i)
  end
end
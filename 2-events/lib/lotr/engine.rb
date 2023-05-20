module Lotr
  class Engine
    attr_reader :registration

    def initialize
      @registration = Registration.new

      # @registration.subscribe 'characters.created' do |event|
      #   p event.inspect
      #   p event[:character].name
      # end
      listener = Listener.new
      @registration.subscribe listener
    end
  end
end
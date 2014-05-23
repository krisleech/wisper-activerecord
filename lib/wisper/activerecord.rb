require "wisper/activerecord/version"
require "wisper/activerecord/injector"

module Wisper
  module Activerecord
    def self.subscribe(klass, options)
      listener = options.fetch(:to)

      Injector.inject(klass)
      Wisper.add_listener(listener, scope: klass)
    end

  end
end

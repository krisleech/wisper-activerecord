require "wisper/activerecord/version"
require "wisper/activerecord/publisher"

module Wisper
  module Activerecord
    def self.subscribe(klass, options)
      listener = options.fetch(:to)

      klass.class_eval { include Wisper::Activerecord::Publisher }
      Wisper.add_listener(listener, scope: klass)
    end
  end
end

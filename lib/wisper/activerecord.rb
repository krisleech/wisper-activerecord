require "wisper/activerecord/version"

module Wisper
  module Activerecord
    def self.subscribe(klass, options)
      listener = options.fetch(:to)
      listener.on_create(Meeting.new)
    end
  end
end

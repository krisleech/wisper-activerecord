module Wisper
  module Activerecord
    class Injector
      def initialize(klass)
        @klass = klass
      end

      def inject
        klass.class_eval do

        end
      end

      def self.inject(klass)
        new(klass).inject
      end

      private

      attr_reader :klass
    end
  end
end

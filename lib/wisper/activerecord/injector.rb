module Wisper
  module Activerecord
    class Injector
      def initialize(klass)
        @klass = klass
      end

      def inject
        klass.class_eval do
          include Wisper::Publisher

          after_create :publish_creation
          after_update :publish_update

          private

          def publish_creation
            broadcast(:on_create, self)
          end

          def publish_update
            broadcast(:on_update, self)
          end
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

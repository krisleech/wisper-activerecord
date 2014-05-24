module Wisper
  module Activerecord
    module Publisher
      extend ActiveSupport::Concern
      included do

        include Wisper::Publisher

        after_create :publish_creation
        after_update :publish_update
        after_destroy :publish_destroy

      end

      private

      def publish_creation
        broadcast(:on_create, self)
      end

      def publish_update
        broadcast(:on_update, self)
      end

      def publish_destroy
        broadcast(:on_destroy, self)
      end
    end
  end
end

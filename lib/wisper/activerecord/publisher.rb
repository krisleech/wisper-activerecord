module Wisper
  module Activerecord
    module Publisher
      extend ActiveSupport::Concern
      included do

        include Wisper::Publisher

        after_create :publish_creation
        after_update :publish_update

      end

      private

      def publish_creation
        broadcast(:on_create, self)
      end

      def publish_update
        broadcast(:on_update, self)
      end
    end
  end
end

module Wisper
  module ActiveRecord
    module Publisher
      extend ActiveSupport::Concern
      included do

        include Wisper::Publisher

        after_commit :publish_creation, on: :create
        after_commit :publish_update,   on: :update
        after_commit :publish_destroy,  on: :destroy
      end

      private

      def publish_creation
        broadcast(:after_create, self)
        broadcast("create_#{self.class.name.downcase}_successful", self)
      end

      def publish_update
        broadcast(:after_update, self)
        broadcast("update_#{self.class.name.downcase}_successful", self)
      end

      def publish_destroy
        broadcast(:after_destroy, self)
        broadcast("destroy_#{self.class.name.downcase}_successful", self)
      end
    end
  end
end

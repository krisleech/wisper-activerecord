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

      def commit(_attributes = nil)
        _action = new_record? ? 'create' : 'update'
        assign_attributes(_attributes) if _attributes.present?
        result = save
        if result
          broadcast("#{_action}_#{self.class.model_name.param_key}_successful", self)
        else
          broadcast("#{_action}_#{self.class.model_name.param_key}_failed", self)
        end
        result
      end

      module ClassMethods
        def commit(_attributes = nil)
          new(_attributes).commit
        end
      end

      private

      def publish_creation
        broadcast(:after_create, self)
      end

      def publish_update
        broadcast(:after_update, self)
      end

      def publish_destroy
        broadcast(:after_destroy, self)
        broadcast("destroy_#{self.class.model_name.param_key}_successful", self)
      end
    end
  end
end

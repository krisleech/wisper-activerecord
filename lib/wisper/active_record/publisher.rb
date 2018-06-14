require 'wisper'

module Wisper
  module ActiveRecord
    module Publisher
      extend ActiveSupport::Concern
      included do
        include Wisper::Publisher

        before_validation :before_validation_broadcast
        before_create     :before_create_broadcast
        before_update     :before_update_broadcast
        before_destroy    :before_destroy_broadcast
        before_save       :before_save_broadcast
        after_validation  :after_validation_broadcast
        after_create      :after_create_broadcast
        after_update      :after_update_broadcast
        after_destroy     :after_destroy_broadcast
        after_save        :after_save_broadcast
        after_commit      :after_commit_broadcast
        after_rollback    :after_rollback_broadcast
      end

      private

      def before_validation_broadcast
        broadcast(:before_validation, self)
        broadcast("before_#{broadcast_model_name_key}_validated", self)
      end

      def before_create_broadcast
        broadcast(:before_create, self)
        broadcast("before_#{broadcast_model_name_key}_created", self)
      end

      def before_update_broadcast
        broadcast(:before_update, self)
        broadcast("before_#{broadcast_model_name_key}_updated", self)
      end

      def before_destroy_broadcast
        broadcast(:before_destroy, self)
        broadcast("before_#{broadcast_model_name_key}_destroyed", self)
      end

      def before_save_broadcast
        broadcast(:before_save, self)
        broadcast("before_#{broadcast_model_name_key}_saved", self)
      end

      def after_validation_broadcast
        action = new_record? ? 'create' : 'update'
        broadcast("#{action}_#{broadcast_model_name_key}_failed", self) unless errors.empty?
        broadcast(:after_validation, self)
        broadcast("after_#{broadcast_model_name_key}_validated", self) unless errors.any?
      end

      def after_create_broadcast
        broadcast(:after_create, self)
        broadcast("after_#{broadcast_model_name_key}_created", self)
      end

      def after_update_broadcast
        broadcast(:after_update, self)
        broadcast("after_#{broadcast_model_name_key}_updated", self)
      end

      def after_destroy_broadcast
        broadcast(:after_destroy, self)
        broadcast("after_#{broadcast_model_name_key}_destroyed", self)
      end

      def after_save_broadcast
        broadcast(:after_save, self)
        broadcast("after_#{broadcast_model_name_key}_saved", self)
      end

      def after_commit_broadcast
        broadcast(:after_commit, self)
        broadcast("after_#{broadcast_model_name_key}_committed", self)
        broadcast("#{broadcast_model_name_key}_committed", self)
      end

      def after_rollback_broadcast
        broadcast(:after_rollback, self)
        broadcast("after_#{broadcast_model_name_key}_rolled_back", self)
      end

      def broadcast_model_name_key
        self.class.model_name.param_key
      end
    end
  end
end

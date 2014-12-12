module Wisper
  module ActiveChanges
    module Publisher
      extend ActiveSupport::Concern
      included do

        include Wisper::Publisher

        after_validation :after_validation_broadcast
        after_commit     :after_create_broadcast,  on: :create
        after_commit     :after_update_broadcast,  on: :update
        after_commit     :after_destroy_broadcast, on: :destroy
        after_rollback   :after_rollback_broadcast
      end

      private

      def after_validation_broadcast
        action = new_record? ? 'create' : 'update'
        broadcast("#{action}_#{self.class.model_name.param_key}_failed", self.id, self.changes) unless errors.empty?
      end

      def after_create_broadcast
        broadcast(:after_create, self.id, self.changes)
        broadcast("create_#{self.class.model_name.param_key}_successful", self.id, self.changes)
      end

      def after_update_broadcast
        broadcast(:after_update, self.id, self.changes)
        broadcast("update_#{self.class.model_name.param_key}_successful", self.id, self.changes)
      end

      def after_destroy_broadcast
        broadcast(:after_destroy, self.id, self.changes)
        broadcast("destroy_#{self.class.model_name.param_key}_successful", self.id, self.changes)
      end

      def after_rollback_broadcast
        broadcast(:after_rollback, self.id, self.changes)
      end
    end
  end
end

module Wisper
  module ActiveTracker
    module Tracker
      extend ActiveSupport::Concern

      module ClassMethods
        def has_tracker(options = {})
          include Wisper::Publisher

          after_validation :__track_after_validation_broadcast
          after_commit     :__track_after_create_broadcast,  on: :create
          after_commit     :__track_after_update_broadcast,  on: :update
          after_commit     :__track_after_destroy_broadcast, on: :destroy
          after_rollback   :__track_after_rollback_broadcast
          before_destroy   :__track_before_destroy_broadcast

          class_attribute  :__tracker_options
          self.__tracker_options = options.dup
        end
      end

      private

      def __track_after_validation_broadcast
        action = new_record? ? 'create' : 'update'
        broadcast("#{action}_#{self.class.model_name.param_key}_failed", __tracker_args_broadcast) unless errors.empty?
      end

      def __track_after_create_broadcast
        broadcast(:after_create, __tracker_args_broadcast)
        broadcast("create_#{self.class.model_name.param_key}_successful", __tracker_args_broadcast)
      end

      def __track_after_update_broadcast
        broadcast(:after_update, __tracker_args_broadcast)
        broadcast("update_#{self.class.model_name.param_key}_successful", __tracker_args_broadcast)
      end

      def __track_after_destroy_broadcast
        broadcast(:after_destroy, __tracker_args_broadcast)
        broadcast("destroy_#{self.class.model_name.param_key}_successful", __tracker_args_broadcast)
      end

      def __track_after_rollback_broadcast
        broadcast(:after_rollback, __tracker_args_broadcast)
      end

      def __track_before_destroy_broadcast
        broadcast(:before_destroy, __tracker_args_broadcast)
      end

      def __tracker_args_broadcast
        args = {}

        args[:tenant] = Apartment::Tenant.current if defined?(Apartment)

        if self.respond_to?(:tracker_args)
          args.merge(self.tracker_args)
        else

          if self.__tracker_options[:model]
            args[:model] = self
          else
            args[:id] = self.id
          end

          unless self.__tracker_options[:skip_changes]
            args[:changes] = self.changes.dup
          end

        end

        args
      end
    end
  end
end

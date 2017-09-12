module Wisper
  module ActiveTracker
    module Tracker
      extend ActiveSupport::Concern

      included do
        include Wisper::Publisher

        after_validation :__track_after_validation_broadcast
        after_commit     :__track_after_create_broadcast,  on: :create
        after_commit     :__track_after_update_broadcast,  on: :update
        after_commit     :__track_after_destroy_broadcast, on: :destroy
        after_commit     :__track_after_commit_broadcast
        after_rollback   :__track_after_rollback_broadcast
        before_destroy   :__track_before_destroy_broadcast
      end

      private

      def __track_after_validation_broadcast
        action = new_record? ? 'create' : 'update'
        broadcast("#{action}_#{__tracker_broadcast_key}_failed", __tracker_args_broadcast) unless errors.empty?
      end

      def __track_after_create_broadcast
        broadcast(:after_create, __tracker_args_broadcast)
        broadcast("create_#{__tracker_broadcast_key}_successful", __tracker_args_broadcast)
      end

      def __track_after_update_broadcast
        broadcast(:after_update, __tracker_args_broadcast)
        broadcast("update_#{__tracker_broadcast_key}_successful", __tracker_args_broadcast)
      end

      def __track_after_destroy_broadcast
        broadcast(:after_destroy, __tracker_args_broadcast)
        broadcast("destroy_#{__tracker_broadcast_key}_successful", __tracker_args_broadcast)
      end

      def __track_after_commit_broadcast
        broadcast(:after_commit, __tracker_args_broadcast)
        broadcast("#{__tracker_broadcast_key}_committed", __tracker_args_broadcast)
      end

      def __track_after_rollback_broadcast
        broadcast(:after_rollback, __tracker_args_broadcast)
      end

      def __track_before_destroy_broadcast
        broadcast(:before_destroy, __tracker_args_broadcast)
      end

      def __tracker_broadcast_key
        self.class.model_name.param_key
      end

      def __tracker_args_broadcast
        args = {
          id: id,
          global_id: (id.present? ? to_global_id : nil)
        }

        args.merge(default_tracker_args) if respond_to?(:default_tracker_args)
        args.merge(tracker_args) if respond_to?(:tracker_args)

        args[:model] ||= self
        args[:changes] ||= changes.dup

        args
      end
    end
  end
end

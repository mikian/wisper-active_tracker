require 'wisper/active_tracker/version'
require 'wisper/active_tracker/tracker'

module Wisper
  module ActiveTracker
    extend ActiveSupport::Concern

    included do
      include Tracker
    end

    def self.extend_all
      ::ActiveRecord::Base.class_eval { include Wisper.tracker }
    end
  end
end

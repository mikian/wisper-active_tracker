require "wisper/active_tracker/version"
require "wisper/active_tracker/tracker"

module Wisper
  def self.tracker
    ::Wisper::ActiveTracker::Tracker
  end

  module ActiveTracker
    def self.extend_all
      ::ActiveRecord::Base.class_eval { include Wisper.tracker }
    end
  end
end

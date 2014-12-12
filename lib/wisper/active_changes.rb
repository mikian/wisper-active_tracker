require "wisper/active_changes/version"
require "wisper/active_changes/publisher"

module Wisper
  def self.model
    ::Wisper::ActiveChanges::Publisher
  end

  module ActiveChanges
    def self.extend_all
      ::ActiveRecord::Base.class_eval { include Wisper.model }
    end
  end
end
